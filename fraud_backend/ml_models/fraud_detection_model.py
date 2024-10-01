import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, accuracy_score
import joblib

class FraudDetectionModel:
    def __init__(self, data_path):
        self.data_path = data_path
        self.model = RandomForestClassifier(n_estimators=100, random_state=42)

    def load_data(self):
        # Load dataset from CSV
        data = pd.read_csv(self.data_path)
        return data

    def preprocess_data(self, data):
        # Basic preprocessing
        # Here you can implement more sophisticated preprocessing based on your dataset
        # Assuming the last column is the target variable
        X = data.iloc[:, :-1]  # Features
        y = data.iloc[:, -1]   # Target variable
        return X, y

    def train(self):
        # Load and preprocess the data
        data = self.load_data()
        X, y = self.preprocess_data(data)

        # Split the data into training and test sets
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        # Train the model
        self.model.fit(X_train, y_train)

        # Make predictions and evaluate the model
        y_pred = self.model.predict(X_test)
        print("Accuracy:", accuracy_score(y_test, y_pred))
        print("Classification Report:\n", classification_report(y_test, y_pred))

    def save_model(self, filename):
        # Save the trained model to a file
        joblib.dump(self.model, filename)
        print(f'Model saved to {filename}')

    def load_model(self, filename):
        # Load a trained model from a file
        self.model = joblib.load(filename)
        print(f'Model loaded from {filename}')

# Example usage:
# model = FraudDetectionModel(data_path='data/ml_training_data.csv')
# model.train()
# model.save_model('fraud_detection_model.joblib')
