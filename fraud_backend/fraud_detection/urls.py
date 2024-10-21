from django.urls import path
from .views.auth_views import UserRegistrationView, LogoutView, LoginView, UserProfileView
from .views.api_views import TransactionListView, TransactionDetailView, TransactionCreateView, TransactionProcessView, CheckFraudView

urlpatterns = [
    # Home view
    path('', HomeView.as_view(), name='home'),  # Add this line for the home view

    # User authentication
    path('register/', UserRegistrationView.as_view(), name='user_registration'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('profile/', UserProfileView.as_view(), name='user_profile'),

    # URL patterns for transaction management
    path('transactions/', TransactionListView.as_view(), name='transaction_list'),
    path('transactions/create/', TransactionCreateView.as_view(), name='transaction_create'),
    path('transactions/<int:pk>/', TransactionDetailView.as_view(), name='transaction_detail'),
    path('transactions/<int:pk>/process/', TransactionProcessView.as_view(), name='transaction_process'),
    path('transactions/<int:pk>/check_fraud/', CheckFraudView.as_view(), name='check_fraud'),
]
