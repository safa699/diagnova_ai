
import joblib
import pandas as pd

# Load saved model
saved_data = joblib.load("diagnova_model.pkl")

model = saved_data["model"]
symptoms = saved_data["symptoms"]

# Example patient symptoms
patient_data = {
    "fever": 1,
    "cough": 1,
    "headache": 0,
    "sore_throat": 1,
    "runny_nose": 1,
    "fatigue": 0,
    "nausea": 0,
    "body_pain": 0
}

# Convert input into DataFrame
input_data = pd.DataFrame([patient_data])
input_data = input_data[symptoms]

# Predict condition
prediction = model.predict(input_data)

print("Entered symptoms:")
for symptom, value in patient_data.items():
    if value == 1:
        print("-", symptom)

print("\nModel output:", prediction[0])
print("This is an educational prediction, not a medical diagnosis.")
