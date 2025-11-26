#!/bin/bash
#!/usr/bin/env bash

IMG="$HOME/Pictures/awareness/awareness.png"

wget -O "$IMG" "https://awareness.rbind.io/images/ducky.png"

gsettings set org.gnome.desktop.background picture-uri "file://$IMG"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$IMG"
