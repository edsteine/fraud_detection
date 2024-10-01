from django.db import models
from django.conf import settings

class Transaction(models.Model):
    """
    Model representing a financial transaction.
    """
    TRANSACTION_TYPES = [
        ('credit', 'Credit'),
        ('debit', 'Debit'),
    ]

    user = models.ForeignKey(  # Keeping this as 'user' is conventional
        settings.AUTH_USER_MODEL, 
        on_delete=models.CASCADE, 
        related_name='transactions'
    )
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    transaction_date = models.DateTimeField(auto_now_add=True)
    description = models.TextField(blank=True, null=True)
    is_fraud = models.BooleanField(default=False)
    category = models.CharField(max_length=100, blank=True, null=True)
    transaction_type = models.CharField(max_length=10, choices=TRANSACTION_TYPES, default='credit')  # Set a default value here

    def __str__(self):
        return f"Transaction of {self.amount} by {self.user.username}"  # Use user.username for clarity

    class Meta:
        verbose_name = 'Transaction'
        verbose_name_plural = 'Transactions'
        ordering = ['-transaction_date']
