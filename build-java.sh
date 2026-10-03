#!/bin/bash
set -e

echo "=== Building Heaven Chrome Java Edition (OpenJDK 21) ==="
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JAVA_DIR="$ROOT_DIR/java"
SRC_DIR="$JAVA_DIR/src/main/java"
OUT_DIR="$JAVA_DIR/bin"
CLASSES_DIR="$JAVA_DIR/build/classes"
JAR_FILE="$OUT_DIR/heaven-chrome.jar"

mkdir -p "$OUT_DIR"
mkdir -p "$CLASSES_DIR"

echo "Compiling Java sources with javac..."
javac -d "$CLASSES_DIR" $(find "$SRC_DIR" -name "*.java")

echo "Packaging executable JAR: $JAR_FILE..."
cat << 'EOF' > "$JAVA_DIR/build/MANIFEST.MF"
Manifest-Version: 1.0
Main-Class: com.heavenchrome.Main
Created-By: Antigravity IDE (Heaven-Chrome)
EOF

jar cfm "$JAR_FILE" "$JAVA_DIR/build/MANIFEST.MF" -C "$CLASSES_DIR" .
chmod +x "$JAR_FILE"

echo ""
echo "========================================="
echo "  JAVA BUILD SUCCESSFUL!"
echo "========================================="
echo "  JAR Output: java/bin/heaven-chrome.jar"
echo "  Size:       $(du -h "$JAR_FILE" | cut -f1)"
echo "  Launcher:   ./run-java.sh"
echo "========================================="
echo ""
echo "To test locally:"
echo "  ./run-java.sh"
echo "  or: java -jar java/bin/heaven-chrome.jar"
echo "========================================="
