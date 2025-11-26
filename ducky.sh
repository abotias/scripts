#!/bin/bash
#!/usr/bin/env bash

IMG="$HOME/Pictures/awareness/awareness.png"

wget -q -O "$IMG" "https://raw.githubusercontent.com/abotias/scripts/refs/heads/main/img/ducky.png"

gsettings set org.gnome.desktop.background picture-uri "file://$IMG"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$IMG"
