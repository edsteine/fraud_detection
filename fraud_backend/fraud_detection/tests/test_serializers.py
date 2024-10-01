from rest_framework.exceptions import ValidationError
from rest_framework import status
from rest_framework.test import APITestCase
from .models.user import User
from .models.transaction import Transaction
from .serializers import UserSerializer, TransactionSerializer, TransactionCreateSerializer

class UserSerializerTestCase(APITestCase):
    """
    Test cases for the UserSerializer.
    """
    def setUp(self):
        self.user_data = {
            'username': 'testuser',
            'email': 'testuser@example.com',
            'first_name': 'Test',
            'last_name': 'User',
        }
        self.user = User.objects.create_user(**self.user_data)

    def test_user_serializer(self):
        serializer = UserSerializer(instance=self.user)
        self.assertEqual(serializer.data, {
            'id': self.user.id,
            'username': self.user.username,
            'email': self.user.email,
            'first_name': self.user.first_name,
            'last_name': self.user.last_name,
        })


class TransactionSerializerTestCase(APITestCase):
    """
    Test cases for the TransactionSerializer.
    """
    def setUp(self):
        self.user_data = {
            'username': 'testuser',
            'email': 'testuser@example.com',
            'first_name': 'Test',
            'last_name': 'User',
        }
        self.user = User.objects.create_user(**self.user_data)

        self.transaction_data = {
            'user': self.user,
            'amount': 100.0,
            'transaction_date': '2024-09-24',  # Adjusted to transaction_date
            'description': 'Test Transaction',
            'is_fraud': False,  # Adjusted to is_fraud
        }
        self.transaction = Transaction.objects.create(**self.transaction_data)

    def test_transaction_serializer(self):
        serializer = TransactionSerializer(instance=self.transaction)
        self.assertEqual(serializer.data, {
            'id': self.transaction.id,
            'user': self.user.id,
            'amount': self.transaction.amount,
            'transaction_date': str(self.transaction.transaction_date),  # Adjusted to transaction_date
            'description': self.transaction.description,
            'is_fraud': self.transaction.is_fraud,  # Adjusted to is_fraud
        })

    def test_transaction_create_serializer(self):
        new_transaction_data = {
            'amount': 150.0,
            'transaction_date': '2024-09-25',  # Adjusted to transaction_date
            'description': 'New Transaction',
        }
        serializer = TransactionCreateSerializer(data=new_transaction_data, context={'request': self.user})

        self.assertTrue(serializer.is_valid())
        transaction = serializer.save()
        self.assertEqual(transaction.amount, 150.0)
        self.assertEqual(transaction.description, 'New Transaction')
        self.assertEqual(transaction.user, self.user)

    def test_transaction_create_serializer_invalid(self):
        serializer = TransactionCreateSerializer(data={'amount': -50.0}, context={'request': self.user})
        
        self.assertFalse(serializer.is_valid())
        self.assertIn('amount', serializer.errors)
