# iroha_service.py
from iroha import Iroha, IrohaCrypto, IrohaGrpc
from datetime import datetime
import json
import time

class TradingAccount:
    def __init__(self, account_id, private_key):
        self.account_id = account_id
        self.private_key = private_key
        self.iroha = Iroha(account_id)
        self.net = IrohaGrpc('localhost:50051')

    def create_account(self, new_account_id, domain_id='test'):
        try:
            private_key = IrohaCrypto.private_key()
            public_key = IrohaCrypto.derive_public_key(private_key)
            
            tx = self.iroha.transaction([
                self.iroha.command('CreateAccount', 
                    account_name=new_account_id,
                    domain_id=domain_id,
                    public_key=public_key
                )
            ])
            
            IrohaCrypto.sign_transaction(tx, self.private_key)
            self.net.send_tx(tx)
            
            # Initialize account details after creation
            # time.sleep(2)
            init_tx = self.iroha.transaction([
                self.iroha.command('SetAccountDetail',
                    account_id=f"{new_account_id}@{domain_id}",
                    key='principal_balance',
                    value='0.0'
                ),
                self.iroha.command('SetAccountDetail',
                    account_id=f"{new_account_id}@{domain_id}",
                    key='interest_balance',
                    value='0.0'
                ),
                self.iroha.command('SetAccountDetail',
                    account_id=f"{new_account_id}@{domain_id}",
                    key='trading_volume',
                    value='0.0'
                ),
                self.iroha.command('SetAccountDetail',
                    account_id=f"{new_account_id}@{domain_id}",
                    key='last_interest_calc',
                    value=str(datetime.now().timestamp())
                )
            ])
            
            IrohaCrypto.sign_transaction(init_tx, self.private_key)
            self.net.send_tx(init_tx)
            time.sleep(5)
            
            return private_key, public_key
        except Exception as e:
            print(f"Create account error: {str(e)}")
            raise e

    def calculate_interest_rate(self, total_balance, trading_volume):
        base_rate = 0.03
        
        if float(total_balance) >= 100000:
            base_rate += 0.02
        elif float(total_balance) >= 50000:
            base_rate += 0.01
            
        if float(trading_volume) >= 1000000:
            base_rate += 0.02
        elif float(trading_volume) >= 500000:
            base_rate += 0.01
            
        return base_rate

    def get_account_details(self, account_id: str):
        query = self.iroha.query('GetAccountDetail', account_id=account_id)
        IrohaCrypto.sign_query(query, self.private_key)
        response = self.net.send_query(query)
        # time.sleep(5)
        max_retries = 60
        retry_delay = 1
        
        for attempt in range(max_retries):
            if response is not None and response.account_detail_response.detail:
                account_details = json.loads(response.account_detail_response.detail)
                first_account = next(iter(account_details.values()))
                
                return {
                    'principal_balance': float(first_account.get('principal_balance', 0)),
                    'interest_balance': float(first_account.get('interest_balance', 0)),
                    'trading_volume': float(first_account.get('trading_volume', 0)),
                    'last_interest_calc': float(first_account.get('last_interest_calc', 0))
                }
            print(f"Polling for updated account info: {attempt}", response, response.account_detail_response)
            time.sleep(retry_delay)
        
        detail = response.account_detail_response.detail
        if not detail:
            return {
                'principal_balance': 0.0,
                'interest_balance': 0.0,
                'trading_volume': 0.0,
                'last_interest_calc': datetime.now().timestamp()
            }

    def calculate_interest(self, account_id: str):
        account_details = self.get_account_details(account_id)
        
        principal_balance = account_details['principal_balance']
        interest_balance = account_details['interest_balance']
        total_balance = principal_balance + interest_balance
        trading_volume = account_details['trading_volume']
        last_calc = account_details['last_interest_calc']
        
        current_time = datetime.now().timestamp()
        minutes_elapsed = (current_time - last_calc) / 60
        
        interest_rate = self.calculate_interest_rate(total_balance, trading_volume)
        
        if minutes_elapsed >= 5:
            annual_rate = interest_rate
            minute_rate = annual_rate / (365 * 24 * 60)
            new_interest = total_balance * minute_rate * int(minutes_elapsed)
            new_interest_balance = interest_balance + new_interest
            
            tx = self.iroha.transaction([
                self.iroha.command('SetAccountDetail',
                    account_id=account_id,
                    key='interest_balance',
                    value=str(new_interest_balance)
                ),
                self.iroha.command('SetAccountDetail',
                    account_id=account_id,
                    key='last_interest_calc',
                    value=str(current_time)
                )
            ])
            
            IrohaCrypto.sign_transaction(tx, self.private_key)
            self.net.send_tx(tx)
            # time.sleep(5)
            account_details = self.get_account_details(account_id)
            max_retries = 60
            retry_delay = 1
            
            for attempt in range(max_retries):
                account_details = self.get_account_details(account_id)
                if account_details is not None and account_details.get('interest_balance', 0) > interest_balance:
                    return {
                        'balance': principal_balance + new_interest_balance,
                        'principal_balance': principal_balance,
                        'interest_balance': new_interest_balance,
                        'interest_rate': interest_rate,
                        'trading_volume': trading_volume,
                        'new_interest': new_interest,  # Add this
                        'minutes_elapsed': minutes_elapsed
                    }
                print(f"Polling for updated interest balance info: {attempt}")
                time.sleep(retry_delay)
        return {
            'balance': principal_balance + interest_balance,
            'principal_balance': principal_balance, 
            'interest_balance': interest_balance,
            'interest_rate': interest_rate,
            'trading_volume': trading_volume,
            'minutes_elapsed': minutes_elapsed
        }

    def deposit(self, account_id: str, amount: float):
        account_details = self.get_account_details(account_id)
        
        # Update principal balance
        new_principal_balance = account_details['principal_balance'] + amount
        interest_balance = account_details['interest_balance']
        
        tx = self.iroha.transaction([
            self.iroha.command('SetAccountDetail',
                account_id=account_id,
                key='principal_balance',
                value=str(new_principal_balance)
            )
        ])
        
        IrohaCrypto.sign_transaction(tx, self.private_key)
        self.net.send_tx(tx)
        # time.sleep(5)  # Wait for transaction to be processed
    
        # Refresh account details
        max_retries = 60
        retry_delay = 1
        
        for attempt in range(max_retries):
            current_details = self.get_account_details(account_id)
            if current_details is not None and current_details.get('principal_balance', 0) > account_details['principal_balance']:
                total_balance = current_details['principal_balance'] + current_details['interest_balance']
                return total_balance  # Return just the balance number
            print(f"Polling for updated after deposit balance info: {attempt}")
            time.sleep(retry_delay)

    def record_trade(self, account_id: str, amount: float):
        account_details = self.get_account_details(account_id)
        
        principal_balance = account_details['principal_balance']
        interest_balance = account_details['interest_balance']
        trading_volume = account_details['trading_volume']
        
        # Subtract trade amount from principal balance
        new_principal_balance = principal_balance - amount
        if new_principal_balance < 0:
            raise ValueError("Insufficient principal balance")
            
        new_trading_volume = trading_volume + abs(amount)
        
        tx = self.iroha.transaction([
            self.iroha.command('SetAccountDetail',
                account_id=account_id,
                key='principal_balance',
                value=str(new_principal_balance)
            ),
            self.iroha.command('SetAccountDetail',
                account_id=account_id,
                key='trading_volume',
                value=str(new_trading_volume)
            )
        ])
        
        IrohaCrypto.sign_transaction(tx, self.private_key)
        self.net.send_tx(tx)
        # time.sleep(5)  # Wait for transaction to be processed

        # Refresh account details
        max_retries = 60
        retry_delay = 1
        
        for attempt in range(max_retries):
            current_details = self.get_account_details(account_id)
            if current_details is not None and current_details.get('trading_volume', 0) > trading_volume:
                return {
                    'new_balance': current_details['principal_balance'] + current_details['interest_balance'],
                    'trading_volume': current_details['trading_volume']
                }
            print(f"Polling for updated after trade balance info: {attempt}")
            time.sleep(retry_delay)
        

class PowerAccount(TradingAccount):
    def calculate_interest_rate(self, balance, trading_volume):
        base_rate = 0.025  # 2.5%
        
        # Balance tier rates
        if balance >= 10_000_000_000:  # 10B
            balance_rate = 0.015
        elif balance >= 5_000_000_000:  # 5B
            balance_rate = 0.01
        elif balance >= 2_000_000_000:  # 2B
            balance_rate = 0.007
        elif balance >= 500_000_000:    # 500M
            balance_rate = 0.005
        else:
            balance_rate = 0.003
            
        # Trading volume tier rates    
        if trading_volume >= 10_000_000_000:  # 10B
            volume_rate = 0.02
        elif trading_volume >= 5_000_000_000:  # 5B
            volume_rate = 0.015
        elif trading_volume >= 2_000_000_000:  # 2B
            volume_rate = 0.01
        elif trading_volume >= 500_000_000:    # 500M
            volume_rate = 0.007
        else:
            volume_rate = 0.005
            
        return base_rate + balance_rate + volume_rate