#!/usr/bin/env bash

if [ ! -d "NTNH" ]; then
    echo "Cloning NTNH Repository"
    git clone --depth=1 https://github.com/Nuclear-Tech-New-Horizons/NTNH.git
else
    echo "NTNH directory already exists."
fi

echo "Copying contents to modpack-native"
mkdir -p modpack-native
cp -r NTNH/* modpack-native

echo "Native Build Complete"
