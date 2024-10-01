import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder

class DataPreprocessor:
    def __init__(self, data_path):
        self.data_path = data_path
        self.label_encoders = {}
        self.scaler = StandardScaler()

    def load_data(self):
        """Load dataset from CSV."""
        data = pd.read_csv(self.data_path)
        return data

    def handle_missing_values(self, data):
        """Handle missing values in the dataset."""
        # Example: Fill missing values with the mean for numerical columns
        for column in data.select_dtypes(include=['float64', 'int64']).columns:
            data[column].fillna(data[column].mean(), inplace=True)
        
        # Fill missing values in categorical columns with the mode
        for column in data.select_dtypes(include=['object']).columns:
            data[column].fillna(data[column].mode()[0], inplace=True)
        
        return data

    def encode_categorical_variables(self, data):
        """Encode categorical variables using Label Encoding."""
        for column in data.select_dtypes(include=['object']).columns:
            le = LabelEncoder()
            data[column] = le.fit_transform(data[column])
            self.label_encoders[column] = le  # Save the encoder for inverse_transform if needed
        
        return data

    def scale_features(self, X):
        """Scale features using Standard Scaler."""
        return self.scaler.fit_transform(X)

    def preprocess_data(self):
        """Load, preprocess, and split the dataset."""
        # Load data
        data = self.load_data()

        # Handle missing values
        data = self.handle_missing_values(data)

        # Separate features and target
        X = data.iloc[:, :-1]  # Features
        y = data.iloc[:, -1]   # Target variable

        # Encode categorical variables
        X = self.encode_categorical_variables(X)

        # Scale features
        X_scaled = self.scale_features(X)

        return X_scaled, y

# Example usage:
# preprocessor = DataPreprocessor(data_path='data/ml_training_data.csv')
# X, y = preprocessor.preprocess_data()
