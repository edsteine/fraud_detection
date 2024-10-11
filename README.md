# Fraud Detection Project

This project consists of a **Fraud Detection System** that includes both a **Django** backend with a machine learning model for fraud detection and a **Flutter** mobile application for interacting with the system. The mobile app allows users to log in, view transactions, and detect potential fraudulent activities. The backend processes and stores the data, while the mobile app provides a user-friendly interface for end users.

## Overview

This project includes:
- A **Django**-based backend that handles user registration, transaction management, and fraud detection.
- A **Flutter**-based mobile application that allows users to log in, view transactions, and get fraud detection insights powered by a machine learning model.

---

## Features

### Backend (Django + Machine Learning)
- **User registration and authentication**: Users can register and authenticate to access the system.
- **Transaction management**: Users can add transactions, view them, and detect fraud.
- **Machine learning-based fraud detection**: Uses a machine learning model to detect fraudulent transactions.
- **Admin panel**: For managing users and transactions.
- **API**: Provides JSON responses for transactions.

### Mobile App (Flutter)
- **User authentication**: Allows users to log in and out of the app.
- **Dashboard**: Displays a list of user transactions.
- **Transaction details**: View detailed information about each transaction.
- **Fraud detection indicator**: Indicates potential fraud for each transaction.

---

## Technologies Used

### Backend (Django)
- **Framework**: Django
- **Database**: PostgreSQL
- **Machine Learning**: Scikit-learn, Pandas
- **Deployment**: WSGI / ASGI ready, Docker setup
- **Environment Management**: Virtualenv, `.env` configuration

### Mobile App (Flutter)
- **Framework**: Flutter
- **State Management**: Provider
- **HTTP Client**: `http` package for API communication
- **Secure Storage**: Flutter Secure Storage for storing user credentials

---


## Installation

### Backend (Django)

1. **Clone the repository**:
   ```bash
   git clone https://github.com/edsteine/fraud_detection.git
   cd fraud_detection
   ```

2. **Set up virtual environment**:
   ```bash
   python -m venv env
   source env/bin/activate  # On Windows: `env\Scripts\activate`
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables**:
   Create a `.env` file with the following variables:
   ```
   DEBUG=True
   SECRET_KEY=your-secret-key
   DATABASE_URL=postgres://USER:PASSWORD@HOST:PORT/DB_NAME
   ```

5. **Set up the PostgreSQL database**:
   Create a PostgreSQL database and update the `.env` file.

6. **Apply migrations**:
   ```bash
   python manage.py migrate
   ```

7. **Create superuser**:
   ```bash
   python manage.py createsuperuser
   ```

8. **Run the server**:
   ```bash
   python manage.py runserver
   ```

### Mobile App (Flutter)

1. **Clone the repository**:
   ```bash
   git clone https://github.com/edsteine/fraud_mobile.git
   cd fraud_mobile
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   Connect a device or start an emulator, then run the app:
   ```bash
   flutter run
   ```

---

## Machine Learning Setup

- The fraud detection model uses a CSV file (`ml_training_data.csv`) for training.
- You can modify the ML logic in `fraud_detection_model.py` and `data_preprocessing.py`.
- To retrain the model:
  ```bash
  python ml_models/fraud_detection_model.py
  ```

---

## API Integration

- The mobile app communicates with the Django backend via API endpoints.
- Configure the API base URL in `constants.dart`:
  ```dart
  const String apiUrl = 'https://your-api-url.com';
  ```

---

## Running Tests

### Backend (Django)
```bash
python manage.py test
```

### Mobile App (Flutter)
```bash
flutter test
```

---

## Deployment

1. Set up PostgreSQL for the database.
2. Use a web server (e.g., Gunicorn, Nginx) for Django.
3. Configure your deployment with the provided WSGI or ASGI settings.

---

## License

This project is licensed under the MIT License. See the LICENSE file for more information.
