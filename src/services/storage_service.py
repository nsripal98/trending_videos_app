import json
import os
from datetime import datetime
from ..models.transaction import Transaction

class StorageService:
    def __init__(self):
        self.storage_file = "transactions.json"
        self._ensure_storage_file()
        
    def _ensure_storage_file(self):
        if not os.path.exists(self.storage_file):
            with open(self.storage_file, 'w') as f:
                json.dump([], f)

    def save_transaction(self, transaction: Transaction):
        transactions = self.get_all_transactions()
        transactions.append(transaction.to_dict())
        with open(self.storage_file, 'w') as f:
            json.dump(transactions, f)

    def get_all_transactions(self):
        with open(self.storage_file, 'r') as f:
            return json.load(f)

    def get_transactions_by_category(self, category: str):
        return [t for t in self.get_all_transactions() if t['category'] == category]

    def get_transactions_by_date_range(self, start: datetime, end: datetime):
        return [
            t for t in self.get_all_transactions() 
            if start <= datetime.fromisoformat(t['timestamp']) <= end
        ]