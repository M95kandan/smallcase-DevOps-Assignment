import random
from flask import Flask

app = Flask(__name__)

STRINGS = ["Investments", "Smallcase", "Stocks", "buy-the-dip", "TickerTape"]

@app.route("/api/v1", methods=["GET"])
def get_random_string():
    return random.choice(STRINGS)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8081)

    
