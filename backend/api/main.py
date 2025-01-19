from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
from backend.blockchain.iroha_service import TradingAccount
from iroha import IrohaCrypto
import json

app = FastAPI()

# Store admin keys as constants
ADMIN_PRIVATE_KEY = "9e93f5f5b39080698ce0bbd0c6d085c1276d9949a6d77bc38e8872f988ce385d"

# Initialize trading service with admin credentials
trading_service = TradingAccount("admin@test", ADMIN_PRIVATE_KEY)

class AccountCreate(BaseModel):
    username: str

class TradeRequest(BaseModel):
    amount: float

class DepositRequest(BaseModel):
    amount: float

@app.post("/account/create")
async def create_account(account: AccountCreate):
    try:
        private_key, public_key = trading_service.create_account(account.username)
        return {
            "account_id": f"{account.username}@test",
            "private_key": private_key.hex(),
            "public_key": public_key.hex()
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/account/{account_id}/balance")
async def get_balance(account_id: str):
    try:
        query = trading_service.iroha.query('GetAccountDetail', account_id=account_id)
        IrohaCrypto.sign_query(query, trading_service.private_key)
        response = trading_service.net.send_query(query)
        
        if response.HasField('error_response'):
            return {"error": response.error_response.message}
            
        detail = response.account_detail_response.detail
        if not detail:
            return {"error": "No account details found"}
            
        account_details = json.loads(detail)
        first_account = next(iter(account_details.values()))
        
        return {
            "balance": float(first_account['balance']),
            "interest_rate": float(first_account['interest_rate']),
            "trading_volume": float(first_account['trading_volume'])
        }
            
    except Exception as e:
        return {"error": str(e)}

@app.post("/account/{account_id}/deposit")
async def deposit(account_id: str, deposit: DepositRequest):
   try:
       query = trading_service.iroha.query('GetAccountDetail', account_id=account_id)
       IrohaCrypto.sign_query(query, trading_service.private_key)
       response = trading_service.net.send_query(query)
       
       detail = response.account_detail_response.detail
       account_details = json.loads(detail)
       first_account = next(iter(account_details.values()))
       current_balance = float(first_account['balance'])
       
       tx = trading_service.iroha.transaction([
           trading_service.iroha.command('SetAccountDetail',
               account_id=account_id,
               key='balance',
               value=str(current_balance + deposit.amount)
           )
       ])
       
       IrohaCrypto.sign_transaction(tx, trading_service.private_key)
       trading_service.net.send_tx(tx)
       
       return {"new_balance": current_balance + deposit.amount}
   except Exception as e:
       raise HTTPException(status_code=400, detail=str(e))

@app.post("/account/{account_id}/trade")
async def make_trade(account_id: str, trade: TradeRequest):
    try:
        query = trading_service.iroha.query('GetAccountDetail', account_id=account_id)
        IrohaCrypto.sign_query(query, trading_service.private_key)
        response = trading_service.net.send_query(query)
        
        detail = response.account_detail_response.detail
        account_details = json.loads(detail)
        first_account = next(iter(account_details.values()))
        current_balance = float(first_account['balance'])
        trading_volume = float(first_account.get('trading_volume', 0))
        
        if trade.amount > current_balance:
            raise HTTPException(status_code=400, detail="Insufficient funds")
            
        tx = trading_service.iroha.transaction([
            trading_service.iroha.command('SetAccountDetail',
                account_id=account_id,
                key='balance',
                value=str(current_balance - trade.amount)
            ),
            trading_service.iroha.command('SetAccountDetail',
                account_id=account_id,
                key='trading_volume',
                value=str(trading_volume + abs(trade.amount))
            )
        ])
        
        IrohaCrypto.sign_transaction(tx, trading_service.private_key)
        trading_service.net.send_tx(tx)
        
        return {"new_balance": current_balance - trade.amount}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)