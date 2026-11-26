
import pandas as pd
import joblib

from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# 1. Load dataset
data = pd.read_csv("symptoms_dataset.csv")

# 2. Separate symptoms and conditions
X = data.drop("condition", axis=1)
y = data["condition"]

# 3. Create model
model = RandomForestClassifier(
    n_estimators=100,
    random_state=42
)

# 4. Train model using the dataset
model.fit(X, y)

# 5. Check training accuracy
predictions = model.predict(X)
accuracy = accuracy_score(y, predictions)

print("Model training completed!")
print("Training accuracy:", round(accuracy * 100, 2), "%")

# 6. Save model and symptom names
model_data = {
    "model": model,
    "symptoms": list(X.columns)
}

joblib.dump(model_data, "diagnova_model.pkl")

print("Model saved successfully!")
print("File: diagnova_model.pkl")
