#!/usr/bin/env bash
set -e

if [ ! -d "NTNH" ]; then
    echo "Cloning NTNH Repository"
    git clone --depth=1 https://github.com/Nuclear-Tech-New-Horizons/NTNH.git
else
    echo "NTNH directory already exists."

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
exit
