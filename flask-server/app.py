from flask import *
from flask_cors import CORS
import pymongo

app = Flask(__name__, static_folder="static", template_folder="template")
CORS(app)

DB = pymongo.MongoClient("mongodb://localhost:27017/")
Collections = DB["boltfix"]
Bookings = Collections["bookings"]

@app.route("/", methods=["GET"])
def index():
	return render_template("index.html", data=Bookings.find({"status":"unchecked"}))

@app.route("/mark/<id>")
def mark(id):
	for i in Bookings.find():
		if id == str(i["_id"]):
			Bookings.update_one(i,{"$set":{"status":"checked"}})
	return render_template("index.html", data=Bookings.find({"status":"unchecked"}))

@app.route("/add_data", methods=["POST"])
def add_data():
	Bookings.insert_one(request.form.to_dict())
	return "ok"

if __name__ == '__main__':
	app.run(debug=True)