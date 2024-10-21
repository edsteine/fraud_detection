# fraud_detection/views/HomeView.py
from django.views.generic import TemplateView

class HomeView(TemplateView):
    template_name = 'index.html'  # Ensure this template exists in your templates directory
