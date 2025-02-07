from dataclasses import dataclass
from datetime import datetime
import json

@dataclass
class Transaction:
    amount: float
    merchant: str
    description: str
    category: str = "Other"
    timestamp: datetime = None

    def __post_init__(self):
        if self.timestamp is None:
            self.timestamp = datetime.now()

    def to_dict(self):
        return {
            'amount': self.amount,
            'merchant': self.merchant,
            'category': self.category,
            'description': self.description,
            'timestamp': self.timestamp.isoformat()
        }

    def to_json(self):
        return json.dumps(self.to_dict())

    @classmethod
    def from_dict(cls, data):
        data['timestamp'] = datetime.fromisoformat(data['timestamp'])
        return cls(**data)

    @classmethod
    def from_json(cls, json_str):
        return cls.from_dict(json.loads(json_str))