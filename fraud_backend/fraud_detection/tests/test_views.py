from rest_framework.test import APITestCase
from rest_framework import status
from django.urls import reverse
from .models.user import User
from .models.transaction import Transaction


class AuthViewsTestCase(APITestCase):
    """
    Test cases for authentication views (login, logout, etc.).
    """

    def setUp(self):
        self.user_data = {
            'username': 'testuser',
            'email': 'testuser@example.com',
            'password': 'testpassword123',
        }
        self.user = User.objects.create_user(**self.user_data)

    def test_login_view(self):
        url = reverse('login')
        response = self.client.post(url, {
            'username': self.user_data['username'],
            'password': self.user_data['password']
        })
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('token', response.data)

    def test_invalid_login(self):
        url = reverse('login')
        response = self.client.post(url, {
            'username': 'invaliduser',
            'password': 'wrongpassword'
        })
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class TransactionViewsTestCase(APITestCase):
    """
    Test cases for transaction views (list, create, check fraud).
    """

    def setUp(self):
        self.user_data = {
            'username': 'testuser',
            'email': 'testuser@example.com',
            'password': 'testpassword123',
        }
        self.user = User.objects.create_user(**self.user_data)
        self.client.login(username=self.user_data['username'], password=self.user_data['password'])

        self.transaction_data = {
            'amount': 100.0,
            'date': '2024-09-24',
            'description': 'Test Transaction',
        }
        self.transaction = Transaction.objects.create(user=self.user, **self.transaction_data)

    def test_list_transactions(self):
        url = reverse('transaction-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['description'], self.transaction_data['description'])

    def test_create_transaction(self):
        url = reverse('transaction-create')
        new_transaction_data = {
            'amount': 150.0,
            'date': '2024-09-25',
            'description': 'New Transaction',
        }
        response = self.client.post(url, new_transaction_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Transaction.objects.count(), 2)

    def test_invalid_transaction_create(self):
        url = reverse('transaction-create')
        invalid_transaction_data = {
            'amount': -50.0,
            'date': '2024-09-25',
            'description': 'Invalid Transaction',
        }
        response = self.client.post(url, invalid_transaction_data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_check_fraud(self):
        url = reverse('transaction-check-fraud', args=[self.transaction.id])
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('is_fraudulent', response.data)
