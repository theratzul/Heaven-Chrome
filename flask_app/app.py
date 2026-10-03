#!/usr/bin/env python3
"""
Heaven Chrome - Flask Web Server & Mobile APK Distribution
Serves the HTML5 Canvas game, sound synthesizer, and direct APK download for Android phones.
"""

import os
from flask import Flask, send_from_directory, send_file, jsonify, request

# Base paths
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
WEB_DIR = os.path.join(BASE_DIR, "web")
APK_PATH = os.path.join(BASE_DIR, "android", "app", "build", "outputs", "apk", "debug", "Heaven-Chrome.apk")

app = Flask(__name__, static_folder=None)

@app.route("/")
def index():
    """Serve the main Heaven Chrome HTML5 game."""
    return send_from_directory(WEB_DIR, "index.html")

@app.route("/<path:filename>")
def static_files(filename):
    """Serve static web assets (scripts, styles, icons, fonts)."""
    return send_from_directory(WEB_DIR, filename)

@app.route("/download")
@app.route("/apk")
def download_apk():
    """
    Direct APK download for connected Android devices over local Wi-Fi/LAN.
    Open http://<computer-ip>:5000/download on your phone browser to install directly.
    """
    if os.path.exists(APK_PATH):
        return send_file(
            APK_PATH,
            as_attachment=True,
            download_name="Heaven-Chrome.apk",
            mimetype="application/vnd.android.package-archive"
        )
    return jsonify({
        "error": "APK not found. Please build it first with ./build-android.sh",
        "path": APK_PATH
    }), 404

@app.route("/api/status")
def status():
    """System and game status API."""
    apk_exists = os.path.exists(APK_PATH)
    apk_size_mb = round(os.path.getsize(APK_PATH) / (1024 * 1024), 2) if apk_exists else 0
    return jsonify({
        "game": "Heaven Chrome",
        "author": "popa bogdan",
        "version": "1.0.0",
        "web_dir": WEB_DIR,
        "apk_available": apk_exists,
        "apk_size_mb": apk_size_mb,
        "download_url": request.host_url + "download"
    })

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    print(f"==================================================")
    print(f"  Heaven Chrome - Flask Server Running")
    print(f"  Local Web Game:     http://localhost:{port}/")
    print(f"  Mobile APK Install: http://localhost:{port}/download")
    print(f"  LAN Access:         http://0.0.0.0:{port}/")
    print(f"==================================================")
    app.run(host="0.0.0.0", port=port, debug=False)
