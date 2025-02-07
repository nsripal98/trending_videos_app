import re
from ..models.transaction import Transaction

class SMSService:
    def __init__(self):
        self.sms_patterns = {
            'amount': r'[-\$\d\.,]+',
            'merchant': r'at (\w+)'
        }

    def parse_sms(self, message):
        amount_match = re.search(self.sms_patterns['amount'], message)
        merchant_match = re.search(self.sms_patterns['merchant'], message)

        if amount_match and merchant_match:
            return Transaction(
                amount=amount_match.group(0),
                merchant=merchant_match.group(1),
                description=message
            )
        return None