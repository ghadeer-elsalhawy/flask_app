from flask import Flask, send_from_directory, Response
from datetime import datetime
import zoneinfo
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

request_counter = Counter('http_requests_total', 'Total number of requests per endpoint', ['endpoint'])

@app.route('/gandalf')
def gandalf():
    request_counter.labels(endpoint='/gandalf').inc()
    return send_from_directory('static/images', 'gandalf.jpg')

@app.route('/colombo')
def colombo_time():
    request_counter.labels(endpoint='/colombo').inc()
    colombo_tz = zoneinfo.ZoneInfo("Asia/Colombo")
    now_colombo = datetime.now(tz=colombo_tz)
    formatted_time = now_colombo.strftime("%Y-%m-%d %H:%M:%S")
    return f"Current time in Colombo: {formatted_time}"

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)
