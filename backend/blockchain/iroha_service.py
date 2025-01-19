from iroha import Iroha, IrohaCrypto, IrohaGrpc
from datetime import datetime
import json

class TradingAccount:
    def __init__(self, account_id, private_key):
        self.account_id = account_id
        self.private_key = private_key
        self.iroha = Iroha(account_id)
        self.net = IrohaGrpc('localhost:50051')

    def create_account(self, new_account_id, domain_id='test'):
        """Create a new account"""
        private_key = IrohaCrypto.private_key()
        public_key = IrohaCrypto.derive_public_key(private_key)
        
        tx = self.iroha.transaction([
            self.iroha.command('CreateAccount', 
                account_name=new_account_id,
                domain_id=domain_id,
                public_key=public_key
            ),
            self.iroha.command('SetAccountDetail',
                account_id=f"{new_account_id}@{domain_id}",
                key='balance',
                value='0'
            ),
            self.iroha.command('SetAccountDetail',
                account_id=f"{new_account_id}@{domain_id}",
                key='interest_rate',
                value='0.03'
            ),
            self.iroha.command('SetAccountDetail',
                account_id=f"{new_account_id}@{domain_id}",
                key='trading_volume',
                value='0'
            ),
            self.iroha.command('SetAccountDetail',
                account_id=f"{new_account_id}@{domain_id}",
                key='last_interest_calc',
                value=str(datetime.now().timestamp())
            )
        ])
        
        IrohaCrypto.sign_transaction(tx, self.private_key)
        self.net.send_tx(tx)
        return private_key, public_key

    def calculate_interest_rate(self, balance, trading_volume):
        """Calculate interest rate based on balance and trading volume"""
        base_rate = 0.03
        
        if float(balance) >= 100000:
            base_rate += 0.02
        elif float(balance) >= 50000:
            base_rate += 0.01
            
        if float(trading_volume) >= 1000000:
            base_rate += 0.02
        elif float(trading_volume) >= 500000:
            base_rate += 0.01
            
        return base_rate

    def update_daily_interest(self, account_id):
        """Update daily interest for an account"""
        query = self.iroha.query('GetAccountDetail', account_id=account_id)
        IrohaCrypto.sign_query(query, self.private_key)
        response = self.net.send_query(query)
        
        detail = response.account_detail_response.detail
        if not detail:
            print(f"No details found for account {account_id}")
            return None
            
        try:
            account_details = json.loads(detail)
        except json.JSONDecodeError:
            print(f"Invalid JSON in account details: {detail}")
            return None

        last_calc = float(account_details['last_interest_calc'])
        current_time = datetime.now().timestamp()
        days_elapsed = (current_time - last_calc) / (24 * 60 * 60)
        
        if days_elapsed >= 1:
            balance = float(account_details['balance'])
            trading_volume = float(account_details['trading_volume'])
            interest_rate = self.calculate_interest_rate(balance, trading_volume)
            daily_rate = interest_rate / 365
            interest = balance * daily_rate * int(days_elapsed)
            
            tx = self.iroha.transaction([
                self.iroha.command('SetAccountDetail',
                    account_id=account_id,
                    key='balance',
                    value=str(balance + interest)
                ),
                self.iroha.command('SetAccountDetail',
                    account_id=account_id,
                    key='last_interest_calc',
                    value=str(current_time)
                ),
                self.iroha.command('SetAccountDetail',
                    account_id=account_id,
                    key='interest_rate',
                    value=str(interest_rate)
                )
            ])
            
            IrohaCrypto.sign_transaction(tx, self.private_key)
            self.net.send_tx(tx)
            return interest

    def record_trade(self, account_id, trade_amount):
        """Record a trading transaction"""
        self.update_daily_interest(account_id)
        
        query = self.iroha.query('GetAccountDetail', account_id=account_id)
        IrohaCrypto.sign_query(query, self.private_key)
        response = self.net.send_query(query)
        
        detail = response.account_detail_response.detail
        if not detail:
            raise ValueError(f"Account {account_id} not found")
            
        account_details = json.loads(detail)
        current_balance = float(account_details['balance'])
        trading_volume = float(account_details['trading_volume'])
        
        if trade_amount > current_balance:
            raise ValueError("Insufficient funds")
            
        tx = self.iroha.transaction([
            self.iroha.command('SetAccountDetail',
                account_id=account_id,
                key='balance',
                value=str(current_balance - trade_amount)
            ),
            self.iroha.command('SetAccountDetail',
                account_id=account_id,
                key='trading_volume',
                value=str(trading_volume + abs(trade_amount))
            )
        ])
        
        IrohaCrypto.sign_transaction(tx, self.private_key)
        self.net.send_tx(tx)
        return current_balance - trade_amount