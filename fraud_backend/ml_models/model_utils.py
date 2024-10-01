import joblib
from sklearn.metrics import classification_report, confusion_matrix

class ModelUtils:
    def __init__(self, model):
        self.model = model

    def save_model(self, filename):
        """Save the trained model to a file."""
        joblib.dump(self.model, filename)
        print(f"Model saved to {filename}")

    def load_model(self, filename):
        """Load a model from a file."""
        self.model = joblib.load(filename)
        print(f"Model loaded from {filename}")
        return self.model

    def evaluate_model(self, X_test, y_test):
        """Evaluate the model's performance."""
        y_pred = self.model.predict(X_test)
        print("Confusion Matrix:\n", confusion_matrix(y_test, y_pred))
        print("\nClassification Report:\n", classification_report(y_test, y_pred))

    def predict(self, X):
        """Make predictions with the trained model."""
        return self.model.predict(X)

# Example usage:
# from sklearn.ensemble import RandomForestClassifier
# model = RandomForestClassifier()
# model_utils = ModelUtils(model)

# After training the model:
# model_utils.save_model('model/fraud_detection_model.pkl')

# For evaluation:
# model_utils.evaluate_model(X_test, y_test)

# For predictions:
# predictions = model_utils.predict(X_new)
