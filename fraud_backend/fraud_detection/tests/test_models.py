from django.test import TestCase
from fraud_detection.models.user import User
from fraud_detection.models.transaction import Transaction
from django.utils import timezone

class UserModelTest(TestCase):
    """
    Tests for the User model.
    """

    def setUp(self):
        self.user_data = {
            'username': 'testuser',
            'email': 'testuser@example.com',
            'password': 'testpassword123',
        }
        self.user = User.objects.create_user(**self.user_data)

    def test_user_creation(self):
        """Test if a user is created correctly."""
        self.assertEqual(self.user.username, self.user_data['username'])
        self.assertEqual(self.user.email, self.user_data['email'])
        self.assertTrue(self.user.check_password(self.user_data['password']))
        self.assertFalse(self.user.is_staff)  # Default should be non-staff
        self.assertFalse(self.user.is_superuser)  # Default should be non-superuser

    def test_user_str_representation(self):
        """Test the string representation of the User model."""
        self.assertEqual(str(self.user), self.user.username)


class TransactionModelTest(TestCase):
    """
    Tests for the Transaction model.
    """

    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser', email='testuser@example.com', password='testpassword123'
        )
        self.transaction_data = {
            'user': self.user,
            'amount': 150.75,
            'transaction_date': timezone.now(),  # Use transaction_date instead of date
            'description': 'Test Transaction',
        }
        self.transaction = Transaction.objects.create(**self.transaction_data)

    def test_transaction_creation(self):
        """Test if a transaction is created correctly."""
        self.assertEqual(self.transaction.user, self.user)
        self.assertEqual(self.transaction.amount, self.transaction_data['amount'])
        self.assertEqual(self.transaction.description, self.transaction_data['description'])
        self.assertIsInstance(self.transaction.transaction_date, timezone.datetime)  # Adjusted to transaction_date

    def test_transaction_str_representation(self):
        """Test the string representation of the Transaction model."""
        expected_str = f"{self.transaction.user.username} - {self.transaction.amount} - {self.transaction.description}"
        self.assertEqual(str(self.transaction), expected_str)

    def test_transaction_invalid_amount(self):
        """Test if an invalid transaction amount raises an error."""
        with self.assertRaises(ValueError):
            Transaction.objects.create(
                user=self.user,
                amount=-50,  # Invalid negative amount
                transaction_date=timezone.now(),  # Use transaction_date instead of date
                description='Invalid Transaction',
            )
