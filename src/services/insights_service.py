from datetime import datetime, timedelta
from typing import Dict, List
from decimal import Decimal
from ..models.transaction import Transaction

class InsightsService:
    def __init__(self, transaction_service):
        self.transaction_service = transaction_service
        
    def get_daily_summary(self, date: datetime) -> Dict:
        transactions = self.transaction_service.get_transactions_by_date(date)
        return self._calculate_summary(transactions)
    
    def get_weekly_summary(self, date: datetime) -> Dict:
        start_date = date - timedelta(days=date.weekday())
        end_date = start_date + timedelta(days=6)
        transactions = self.transaction_service.get_transactions_by_date_range(start_date, end_date)
        return self._calculate_summary(transactions)
    
    def get_monthly_summary(self, year: int, month: int) -> Dict:
        transactions = self.transaction_service.get_transactions_by_month(year, month)
        return self._calculate_summary(transactions)
        
    def _calculate_summary(self, transactions: List[Transaction]) -> Dict:
        total_income = Decimal('0')
        total_expense = Decimal('0')
        category_totals = {}
        
        for transaction in transactions:
            if transaction.amount > 0:
                total_income += transaction.amount
            else:
                total_expense += abs(transaction.amount)
                
            if transaction.category not in category_totals:
                category_totals[transaction.category] = Decimal('0')
            category_totals[transaction.category] += abs(transaction.amount)
            
        return {
            'total_income': total_income,
            'total_expense': total_expense,
            'net_balance': total_income - total_expense,
            'category_totals': category_totals
        }