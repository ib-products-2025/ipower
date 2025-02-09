# power_models.py
from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

class PowerBalance(BaseModel):
    balance: float
    interest_balance: float
    interest_rate: float
    trading_volume: float
    can_include_in_purchasing_power: bool
    automatic_transfer: bool
    minimum_balance: float

class PowerTransaction(BaseModel):
    id: str
    type: str  # "deposit" or "withdraw"
    amount: float
    timestamp: datetime
    status: str  # "success", "pending", "failed"

class PowerInterest(BaseModel):
    id: str
    amount: float
    rate: float
    timestamp: datetime
    balance_rate: float
    trading_volume_rate: float