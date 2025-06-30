#!/usr/bin/env bash
set -e

echo "Cloning NTNH Repository"
git clone --depth=1 https://github.com/Nuclear-Tech-New-Horizons/NTNH.git

echo "Copying contents to modpack-prism"
mkdir -p modpack-prism/.minecraft
cp -r NTNH/* modpack-prism/.minecraft/

cat > modpack-prism/instance.cfg <<< "
[General]
name=NTNH
iconKey=default
InstanceType=OneSix
"

echo "Prism Build Complete"
