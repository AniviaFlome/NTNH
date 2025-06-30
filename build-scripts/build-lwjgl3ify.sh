#!/usr/bin/env bash

echo "Installing jq"
sudo sudo apt install -y jq

if [ ! -d "NTNH" ]; then
    echo "Cloning NTNH Repository"
    git clone --depth=1 https://github.com/Nuclear-Tech-New-Horizons/NTNH.git
else
    echo "NTNH directory already exists."

echo "Downloading lwjgl3ify"
version=$(curl -s https://api.github.com/repos/GTNewHorizons/lwjgl3ify/releases/latest | jq -r .tag_name)
zip_url="https://github.com/GTNewHorizons/lwjgl3ify/releases/download/$version/lwjgl3ify-${version}-multimc.zip"
jar_url="https://github.com/GTNewHorizons/lwjgl3ify/releases/download/$version/lwjgl3ify-${version}.jar"

curl -L "$zip_url" -o "lwjgl3ify-${version}-multimc.zip"
unzip -q "lwjgl3ify-${version}-multimc.zip" -d lwjgl3ify-multimc
curl -L "$jar_url" -o "lwjgl3ify-${version}.jar"

echo "Copying contents to modpack-lwjgl3ify"
cp -r NTNH/* modpack-lwjgl3ify/.minecraft/

cat > modpack-lwjgl3ify/instance.cfg <<< "
[General]
name=NTNH
iconKey=default
InstanceType=OneSix
"

cp -r lwjgl3ify-multimc/patches modpack-lwjgl3ify/
cp -r lwjgl3ify-multimc/libraries modpack-lwjgl3ify/
cp -r lwjgl3ify-multimc/mmc-pack.json modpack-lwjgl3ify/
cp -r "lwjgl3ify-${version}.jar" modpack-lwjgl3ify/.minecraft/mods/

echo "lwjgl3ify Build Complete"
