from dataclasses import dataclass
from datetime import datetime
from typing import List
from decimal import Decimal

@dataclass
class SplitParticipant:
    user_id: str
    amount: Decimal
    paid: bool = False
    
@dataclass
class SplitTransaction:
    id: str
    transaction_id: str
    title: str
    total_amount: Decimal
    participants: List[SplitParticipant]
    created_at: datetime = None
    
    def __post_init__(self):
        if self.created_at is None:
            self.created_at = datetime.now()