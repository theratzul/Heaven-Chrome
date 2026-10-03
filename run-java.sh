#!/bin/bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JAR_FILE="$ROOT_DIR/java/bin/heaven-chrome.jar"

if [ ! -f "$JAR_FILE" ]; then
    echo "JAR not found. Building first..."
    "$ROOT_DIR/build-java.sh"
fi

echo "Launching Heaven Chrome Java Edition..."
java -jar "$JAR_FILE" "$@"
