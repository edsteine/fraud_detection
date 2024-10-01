import os
import django
from django.core.exceptions import ObjectDoesNotExist

# Set the Django settings module
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'fraud_detection_project.settings')  # Replace 'yourproject' with your actual project name
django.setup()

# Import your User model after setting up Django
# from User.models import User  # Adjust the import based on your app's structure

from fraud_detection.models.user import User

def check_user_exists(username):
    try:
        user_exists = User.objects.filter(username='edsteine').exists()
        return user_exists
    except Exception as e:
        print(f"An error occurred: {e}")
        return False
    
def list_all_users():
    try:
        # Query all users
        users = User.objects.all()
        print(f"all users")
        # Print user details
        for user in users:
            print(f"Username: {user.username}, Email: {user.email}, Other Field: {user.other_field}")  # Adjust based on your User model fields

    except Exception as e:
        print(f"An error occurred: {e}")
if __name__ == '__main__':
    username = 'edsteine'  # Replace with the username you want to check
    if check_user_exists(username):
        print(f"User '{username}' exists.")
    else:
        print(f"User '{username}' does not exist.")
    list_all_users()
