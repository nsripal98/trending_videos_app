import re
from ..models.transaction import Transaction
from .storage_service import StorageService

class TransactionService:
    def __init__(self):
        self.categories = {
            "Amazon": "Shopping",
            "Starbucks": "Dining",
            "rent": "Housing",
        }
        self.storage = StorageService()

    def add_transaction(self, transaction: Transaction):
        if not transaction.category:
            transaction.category = self.categories.get(transaction.merchant, "Other")
        self.storage.save_transaction(transaction)
        return transaction

    def add_manual_transaction(self, amount: float, merchant: str, category: str = None) -> Transaction:
        transaction = Transaction(
            amount=amount,
            merchant=merchant,
            description=f"Manual entry: {amount} at {merchant}",
            category=category or self.categories.get(merchant, "Other")
        )
        return self.add_transaction(transaction)

    def get_all_transactions(self):
        return self.storage.get_all_transactions()

    def process_sms(self, message: str) -> Transaction:
        amount_match = re.search(r'\$?(\d+\.?\d*)', message)
        merchant_match = re.search(r'at (\w+)', message)
        
        if amount_match and merchant_match:
            amount = float(amount_match.group(1))
            merchant = merchant_match.group(1)
            category = self.categories.get(merchant, "Other")
            
            return Transaction(
                amount=amount,
                merchant=merchant,
                description=message,
                category=category
            )
        return None