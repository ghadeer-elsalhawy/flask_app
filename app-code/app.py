from flask import Flask, send_from_directory, Response
from datetime import datetime
import zoneinfo
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

gandalf_counter = Counter('gandalf_requests_total', 'Total number of requests to /gandalf uri')
colombo_counter = Counter('colombo_requests_total', 'Total number of requests to /colombo uri')

@app.route('/gandalf')
def gandalf():
    gandalf_counter.inc()
    return send_from_directory('static/images', 'gandalf.jpg')

@app.route('/colombo')
def colombo_time():
    colombo_counter.inc()
    colombo_tz = zoneinfo.ZoneInfo("Asia/Colombo")
    now_colombo = datetime.now(tz=colombo_tz)
    formatted_time = now_colombo.strftime("%Y-%m-%d %H:%M:%S")
    return f"Current time in Colombo: {formatted_time}"

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)
