#! /usr/bin/env nix-shell
#! nix-shell -i bash -p imagemagick

magick wallpaper.jpg -resize 800x600^ rofi.jpg
