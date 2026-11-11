#!/usr/bin/env bash
# Arma build/ChecklistApp.swiftpm (y su .zip) para abrir en Swift Playgrounds en el iPad.
# La única fuente de código es App/: no editar los archivos dentro de build/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build"
BUNDLE="$BUILD/ChecklistApp.swiftpm"

rm -rf "$BUNDLE" "$BUNDLE.zip"
mkdir -p "$BUNDLE"

cp "$ROOT/Playgrounds/Package.swift" "$BUNDLE/Package.swift"
cp "$ROOT/Playgrounds/AppInfo.plist" "$BUNDLE/AppInfo.plist"
cp -R "$ROOT/App" "$BUNDLE/App"
find "$BUNDLE" -name '.gitkeep' -delete

(cd "$BUILD" && zip -qr "ChecklistApp.swiftpm.zip" "ChecklistApp.swiftpm")

echo "Listo: $BUNDLE.zip"
