#! /usr/bin/env nix-shell
#! nix-shell -i bash -p imagemagick

magick wallpaper.jpg -resize 80x60^ rofi.jpg
