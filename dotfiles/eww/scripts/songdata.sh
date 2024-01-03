#!/usr/bin/env bash

if [[ $1 == "title" ]]; then
  playerctl --no-messages metadata --format "{{ title }}" || echo ""
fi

if [[ $1 == "artist" ]]; then
  playerctl --no-messages metadata --format "{{ artist }}" || echo ""
fi

if [[ $1 == "album" ]]; then
  playerctl --no-messages metadata --format "{{ xesam:album }}" || echo ""
fi

if [[ $1 == "player" ]]; then
  playerctl --no-messages metadata --format "{{ playerName }}" || echo ""
fi

if [[ $1 == "cover" ]]; then
  playerctl --no-messages metadata --format "{{ mpris:artUrl }}" || echo "/home/detroyejr/.config/dotfiles/assets/cover.png"
fi

if [[ $1 == "status" ]]; then
  playerctl --no-messages status || echo 'Paused'
fi

