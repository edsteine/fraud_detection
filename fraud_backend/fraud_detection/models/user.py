from django.contrib.auth.models import AbstractUser, Group, Permission
from django.db import models

class User(AbstractUser):
    """
    Custom User model extending Django's AbstractUser.
    Additional fields can be added here if needed.
    """
    email = models.EmailField(unique=True, verbose_name='email address')
    phone_number = models.CharField(max_length=15, blank=True, null=True, verbose_name='phone number')
    address = models.CharField(max_length=255, blank=True, null=True, verbose_name='address')

    def __str__(self):
        return self.username

    class Meta:
        verbose_name = 'User'
        verbose_name_plural = 'Users'

    groups = models.ManyToManyField(
        Group,
        related_name='fraud_detection_user_set',  # Change this
        blank=True,
        help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.',
        verbose_name='groups',
    )

    user_permissions = models.ManyToManyField(
        Permission,
        related_name='fraud_detection_user_set',  # Change this
        blank=True,
        help_text='Specific permissions for this user.',
        verbose_name='user permissions',
    )
