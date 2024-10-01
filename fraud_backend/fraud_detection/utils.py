import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import requests
import os

# Function to preprocess data for training
def preprocess_data(file_path):
    """
    Load and preprocess the data from a CSV file.
    
    Args:
        file_path (str): Path to the CSV file.

    Returns:
        X (DataFrame): Features for model training.
        y (Series): Target variable.
    """
    # Load the data
    data = pd.read_csv(file_path)

    # Example preprocessing steps
    data.dropna(inplace=True)  # Remove missing values
    X = data.drop('target', axis=1)  # Features
    y = data['target']  # Target variable

    # Standardize features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    return X_scaled, y

# Function to make API requests
def make_api_request(url, data=None, headers=None):
    """
    Make a POST request to a specified URL.
    
    Args:
        url (str): The API endpoint.
        data (dict, optional): The payload to send in the request.
        headers (dict, optional): Any headers for the request.

    Returns:
        response (Response): The response object from the request.
    """
    try:
        if data:
            response = requests.post(url, json=data, headers=headers)
        else:
            response = requests.get(url, headers=headers)

        response.raise_for_status()  # Raise an error for bad responses
        return response.json()  # Return the response JSON
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
        return None

# Example function to get environment variable
def get_env_variable(var_name):
    """
    Retrieve an environment variable.
    
    Args:
        var_name (str): The name of the environment variable.

    Returns:
        str: The value of the environment variable or None if not found.
    """
    return os.environ.get(var_name)
