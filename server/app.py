from flask import Flask, request
from flask_cors import CORS
import os, json, pymongo
from google import genai

app = Flask(__name__)
CORS(app)
GEMINI_API_KEY = "" # Set your Gemini API key here
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

mydb = pymongo.MongoClient("mongodb://localhost:27017/")
boltfix_db = mydb["boltfix"]
orders_db = boltfix_db["orders"]

prompt = """Caption this image of a bike.
if it is a bike return 
{
    "file":true,
    "isBike": "yes",
    "brand": "Brand Name",
    "model": "Model Name",
}
else 
{
    "file":true,
    "isBike": "no",
}"""

def genrate_bike_info(path):
    client = genai.Client(api_key=GEMINI_API_KEY)
    my_file = client.files.upload(file=path)
    response = client.models.generate_content(model="gemini-2.0-flash",contents=[my_file, prompt],)
    if "```json" not in response.text:
        return {"file":False}
    data=json.loads(response.text.replace("\n", "").replace(" ", "").split("```json")[1].replace("```", ""))
    return data


@app.route('/upload', methods=['POST'])
def upload():
    if 'image' not in request.files:
        return {"file":False}
    file = request.files['image']
    if file.filename == '':
        return {"file":False}
    file.save(os.path.join(UPLOAD_FOLDER, file.filename))
    data = genrate_bike_info(os.path.join(UPLOAD_FOLDER, file.filename))
    os.remove(os.path.join(UPLOAD_FOLDER, file.filename))
    return data

@app.route('/order', methods=['GET', 'POST'])
def order():
    if request.method == 'POST':
        data = request.json
        print(data)
        orders_db.insert_one(data)
        return {"status": "success", "message": "Order processed successfully"}
    else:
        return {"status": "error", "message": "Invalid request method"}, 405

@app.route("/admin_dashboard", methods=['GET'])
def admin_dashboard():
    return [i for i in orders_db.find()]

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)