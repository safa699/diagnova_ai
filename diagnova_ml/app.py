
from flask import Flask, request, jsonify
import joblib
import pandas as pd

app = Flask(__name__)

# Load our trained model
saved_data = joblib.load("diagnova_model.pkl")

model = saved_data["model"]
symptoms = saved_data["symptoms"]


@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "message": "Diagnova AI ML server is running!"
    })


@app.route("/predict", methods=["POST"])
def predict():

    # Receive symptoms from Flutter
    data = request.get_json(silent=True)

    if not isinstance(data, dict):
        return jsonify({
            "error": "Please send symptoms as JSON."
        }), 400

    # Check that all required symptoms are provided
    missing_symptoms = [
        symptom for symptom in symptoms
        if symptom not in data
    ]

    if missing_symptoms:
        return jsonify({
            "error": "Missing symptoms",
            "missing": missing_symptoms
        }), 400

    # Validate symptom values: only 0 or 1
    for symptom in symptoms:
        if data[symptom] not in [0, 1]:
            return jsonify({
                "error": f"{symptom} must be 0 or 1."
            }), 400

    # Prepare input for model
    input_data = pd.DataFrame(
        [[data[symptom] for symptom in symptoms]],
        columns=symptoms
    )

    # Get model prediction
    prediction = model.predict(input_data)[0]

    return jsonify({
        "possible_condition": str(prediction),
        "message": "Educational prediction only. Not a medical diagnosis."
    })


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=False
    )
