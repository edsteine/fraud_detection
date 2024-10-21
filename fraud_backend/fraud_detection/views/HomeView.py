from django.views import View

class HomeView(View):
    template_name = 'index.html'  # Ensure this template exists in your templates directory
