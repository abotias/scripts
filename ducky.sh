#!/bin/bash
#!/usr/bin/env bash

IMG="$HOME/Pictures/img.png"

wget -q -O "$IMG" "https://cataas.com/cat"
if [ $? -ne 0 ]; then wget -q -O "$IMG" "https://raw.githubusercontent.com/abotias/scripts/refs/heads/main/img/ducky.png"; fi

gsettings set org.gnome.desktop.background picture-uri "file://$IMG"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$IMG"
exit 0