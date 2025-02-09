from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta
from typing import List
from models.user import User, UserInDB, Token
from blockchain.iroha_service import TradingAccount, PowerAccount
from auth.auth import verify_password, get_password_hash, create_access_token
import json
from pydantic import BaseModel
from iroha import IrohaCrypto
from fastapi import Body
import time
from typing import Optional, List
from fastapi.middleware.trustedhost import TrustedHostMiddleware
import fastapi.encoders
import json

# Add at app initialization 
app = FastAPI(
    default_response_class=fastapi.responses.JSONResponse,
    json_encoder=lambda obj: json.dumps(obj, ensure_ascii=False)
)

app.add_middleware(
    TrustedHostMiddleware,
    allowed_hosts=["*"],
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Store users in memory (replace with database in production)
users_db = {}

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Initialize trading service
ADMIN_PRIVATE_KEY = "9e93f5f5b39080698ce0bbd0c6d085c1276d9949a6d77bc38e8872f988ce385d"
trading_service = TradingAccount("admin@test", ADMIN_PRIVATE_KEY)
power_trading_service = PowerAccount("admin@test", ADMIN_PRIVATE_KEY)

@app.post("/token")
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = users_db.get(form_data.username)
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    
    access_token = create_access_token(data={"sub": user.username})
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "account_id": user.account_id,
        "username": user.username
    }

@app.post("/user/register")
def register(user: User):
    print(f"Received registration request for user: {user.username}")
    try:
        private_key, public_key = trading_service.create_account(user.username)
        print(f"Account created with private key: {private_key.hex()}")
        
        account_id = f"{user.username}@test"
        print(f"Account ID: {account_id}")
        
        # Set initial account details
        tx = trading_service.iroha.transaction([
            trading_service.iroha.command('SetAccountDetail',
                account_id=account_id,
                key='balance',
                value='0.0'
            ),
            trading_service.iroha.command('SetAccountDetail',
                account_id=account_id,
                key='trading_volume',
                value='0.0'
            ),
            trading_service.iroha.command('SetAccountDetail',
                account_id=account_id,
                key='last_interest_calc',
                value=str(datetime.now().timestamp())
            )
        ])

        IrohaCrypto.sign_transaction(tx, trading_service.private_key)
        trading_service.net.send_tx(tx)
        time.sleep(5)
        
        user_in_db = UserInDB(
            username=user.username,
            password=user.password,
            hashed_password=get_password_hash(user.password),
            account_id=account_id,
        )
        users_db[user.username] = user_in_db
        print("User stored in DB")
        
        return {
            "message": "Registration successful",
            "account_id": account_id,
            "private_key": private_key.hex(),
            "public_key": public_key.hex()
        }
    except Exception as e:
        print(f"Registration error: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

class TransactionRecord(BaseModel):
    type: str
    amount: float
    timestamp: datetime

# Transaction and interest tracking
transactions_db = {}
interest_history_db = {}

def record_interest(account_id: str, amount: float, rate: float):
    if account_id not in interest_history_db:
        interest_history_db[account_id] = []

    interest_record = {
        'id': str(len(interest_history_db[account_id]) + 1),
        'amount': amount,
        'rate': rate,
        'timestamp': datetime.now().isoformat()
    }
    interest_history_db[account_id].append(interest_record)
    print(f"Interest history after record: {interest_history_db}")

def record_transaction(account_id: str, transaction_type: str, amount: float):
    if account_id not in transactions_db:
        transactions_db[account_id] = []
    
    transaction = {
        'id': str(len(transactions_db[account_id])),
        'type': transaction_type,
        'amount': amount,
        'timestamp': datetime.now().isoformat(),
        'status': 'Thành công'  # Add default status
    }
    transactions_db[account_id].append(transaction)

@app.post("/account/{account_id}/deposit")
def deposit(account_id: str, amount: float = Body(..., embed=True)):
    try:
        new_total_balance = trading_service.deposit(account_id, amount)
        record_transaction(account_id, 'deposit', amount)
        print(f"After deposit - Full account details: {new_total_balance}")
        return {"new_balance": new_total_balance}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/account/{account_id}/trade")
def trade(account_id: str, amount: float = Body(..., embed=True)):
    try:
        response = trading_service.record_trade(account_id, amount)
        record_transaction(account_id, 'trade', amount)
        print(f"After trade - Full account details: {response}")
        return response
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/account/{account_id}/transactions")
def get_transactions(account_id: str):
    transactions = transactions_db.get(account_id, [])
    print(f"Transactions - Full details: {transactions}")
    return [
        {
            "id": str(idx + 1),
            "type": transaction['type'],
            "amount": transaction['amount'],
            "timestamp": transaction['timestamp']
        }
        for idx, transaction in enumerate(transactions)
    ]

@app.get("/account/{account_id}/interest-history")
def get_interest_history(account_id: str):
    print(f"Interest history details: {interest_history_db}")
    return interest_history_db.get(account_id, [])

@app.get("/account/{account_id}/balance")
def get_balance(account_id: str):
   try:
        balance_info = trading_service.calculate_interest(account_id)
        if balance_info is not None:
            # Only record interest if minutes_elapsed exists and >= 5
            if balance_info.get('minutes_elapsed', 0) >= 5:
                new_interest = balance_info.get('new_interest', 0)
                if new_interest > 0:
                    record_interest(account_id, new_interest, balance_info['interest_rate'])
            return balance_info
           
        return {
           'balance': 0.0,
           'principal_balance': 0.0,
           'interest_balance': 0.0,
           'interest_rate': 0.03,
           'trading_volume': 0.0
        }
   except Exception as e:
        print(e)
        return {
           'balance': 0.0,
           'principal_balance': 0.0,
           'interest_balance': 0.0,
           'interest_rate': 0.03,
           'trading_volume': 0.0
        }

@app.post("/power/{account_id}/deposit") 
async def power_deposit(account_id: str, amount: float = Body(..., embed=True)):
   try:
       new_balance = power_trading_service.deposit(account_id, amount)
       record_transaction(account_id, 'deposit', amount)
       print(f"After deposit - Full account details: {new_balance}")
       return {"status": "success", "new_balance": new_balance}
   except Exception as e:
       print(e)
       raise HTTPException(status_code=400, detail=str(e))

@app.post("/power/{account_id}/withdraw")
async def trade(account_id: str, amount: float = Body(..., embed=True)): 
   try:
       response = power_trading_service.record_trade(account_id, amount)
       record_transaction(account_id, 'trade', amount)
       print(f"After trade - Full account details: {response}")
       return response
   except Exception as e:
       print(e)
       raise HTTPException(status_code=400, detail=str(e))

@app.get("/power/{account_id}/history")
async def get_power_history(
    account_id: str,
    start_date: datetime,
    end_date: datetime,
    status: Optional[str] = None
):
    transactions = transactions_db.get(account_id, [])
    interests = interest_history_db.get(account_id, [])
    
    # Add default status to transactions if missing
    for t in transactions:
        if 'status' not in t:
            t['status'] = 'Thành công'
    
    filtered_transactions = [
        t for t in transactions 
        if start_date <= datetime.fromisoformat(t['timestamp']) <= end_date
        and (status is None or t.get('status', 'Thành công') == status)
    ]
    
    print(f"Status filter: {status}")
    print(f"Filtered transactions: {filtered_transactions}")
    
    filtered_interests = [
        i for i in interests
        if start_date <= datetime.fromisoformat(i['timestamp']) <= end_date
    ]

    return {
        "transactions": filtered_transactions,
        "interest_records": filtered_interests
    }

@app.post("/power/{account_id}/auto-transfer")
async def set_auto_transfer(
    account_id: str,
    enabled: bool,
    deposit_time: Optional[str] = None,
    withdraw_time: Optional[str] = None,
    minimum_balance: Optional[float] = None
):
    return {"status": "success"}

# Add this near the top of main.py with other database declarations
auto_transfer_min_balance_db = {}  # Store minimum balances per account

# Add this new endpoint
# Define standard keys as constants at the top of main.py
# In main.py, replace the existing auto-transfer-balances endpoints with:

ACCOUNT_KEYS = {
    "TK_THUONG": "TK Thường",
    "TK_KY_QUY": "TK Ký quỹ",
    "TK_PHAI_SINH": "TK Phái sinh"
}

# In main.py, update the auto transfer endpoints:

# Add enabled field to the model by adding this:
from typing import Dict, Optional

class AutoTransferSettings(BaseModel):
    balances: Dict[str, float]
    transfer_option: str = 'Nộp'
    enabled: bool = False

# Update the endpoint to use this model:
@app.post("/power/{account_id}/auto-transfer-balances")
async def set_auto_transfer_balances(
    account_id: str,
    settings: AutoTransferSettings,
):
    try:
        # Create normalized settings
        normalized_balances = {}
        for key, value in settings.balances.items():
            # Try to match the incoming key with our standard keys
            standardized_key = None
            for std_key in ACCOUNT_KEYS.values():
                if key.strip() == std_key:
                    standardized_key = std_key
                    break
            
            if standardized_key:
                normalized_balances[standardized_key] = float(value)

        # If we're missing any keys, use defaults
        for std_key in ACCOUNT_KEYS.values():
            if std_key not in normalized_balances:
                normalized_balances[std_key] = 0.0

        # Create complete settings object
        complete_settings = {
            'balances': normalized_balances,
            'transfer_option': settings.transfer_option,
            'enabled': settings.enabled
        }

        auto_transfer_min_balance_db[account_id] = complete_settings
        print(f"Saved settings for {account_id}: {complete_settings}")
        return {"status": "success", "data": complete_settings}
    except Exception as e:
        print(f"Error saving settings: {e}")
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/power/{account_id}/auto-transfer-balances")
async def get_auto_transfer_balances(account_id: str):
    try:
        default_settings = {
            'balances': {
                ACCOUNT_KEYS["TK_THUONG"]: 1000000,
                ACCOUNT_KEYS["TK_KY_QUY"]: 1000000,
                ACCOUNT_KEYS["TK_PHAI_SINH"]: 0,
            },
            'transfer_option': 'Nộp',
            'enabled': False
        }
        
        stored_settings = auto_transfer_min_balance_db.get(account_id)
        if stored_settings:
            # Ensure all keys are present with stored or default values
            final_settings = default_settings.copy()
            if 'balances' in stored_settings:
                final_settings['balances'].update(stored_settings['balances'])
            if 'transfer_option' in stored_settings:
                final_settings['transfer_option'] = stored_settings['transfer_option']
            if 'enabled' in stored_settings:
                final_settings['enabled'] = stored_settings['enabled']
            return final_settings
        return default_settings
    except Exception as e:
        print(f"Error getting settings: {e}")
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/verify-otp")
async def verify_otp(
    account_id: str,
    otp: str,
):
    # For now just validate 4 digits
    if len(otp) == 4:
        return {"status": "success"}
    raise HTTPException(status_code=400, detail="Invalid OTP")

@app.get("/power/{account_id}/balance")
async def get_power_balance(account_id: str):
    try:
        balance_info = power_trading_service.calculate_interest(account_id)
        if balance_info is not None:
            # Only record interest if minutes_elapsed exists and >= 5
            if balance_info.get('minutes_elapsed', 0) >= 5:
                new_interest = balance_info.get('new_interest', 0)
                if new_interest > 0:
                    record_interest(account_id, new_interest, balance_info['interest_rate'])
            
            # Add fields needed by frontend
            balance_info['available_balance'] = balance_info['balance'] 
            balance_info['blocked_balance'] = 0
            return balance_info
    except Exception as e:
        print(f"Error getting balance: {e}")
        
    return {
        'balance': 0.0,
        'principal_balance': 0.0,
        'interest_balance': 0.0,
        'interest_rate': 0.03,
        'trading_volume': 0.0,
        'available_balance': 0.0,
        'blocked_balance': 0.0
    }