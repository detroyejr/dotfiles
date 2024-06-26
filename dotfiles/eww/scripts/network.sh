#!/usr/bin/env bash

symbol() {
  if [ $(cat /sys/class/net/w*/operstate) = up ]
  then
    echo 
  elif [ $(cat /sys/class/net/w*/operstate) = down ]
  then
    echo 󰤭 
  fi
}

name() {
  nmcli -g "TYPE, CONNECTION" device | grep "wifi:" | cut -d: -f 2
}

ncut () {
  toshow="$1"
  maxlen="$2"

  sufix=""

  if test $(echo $toshow | wc -c) -ge $maxlen ; then
    sufix=""
  fi

  echo "${toshow:0:$maxlen}$sufix"
}

[ "$1" = "icon" ] && symbol

if [[ $1 == "ssid" ]]; then
  ssid=$(name)
  if [[ "$ssid" == "" ]]; then
    echo "Disconnected"
  else
    ncut "$ssid" 12
  fi
fi

if [[ $1 == "name" || $1 == "class" ]]; then
  wifiname=$(name)
  if [[ $wifiname == "" ]]; then
    if [[ $1 == "name" ]]; then
      echo "Disconnected"
    elif [[ $1 == "class" ]]; then
      echo "disconnected"
    fi
  else
    if [[ $1 == "name" ]]; then
      echo "Connected to $wifiname"
    elif [[ $1 == "class" ]]; then
      echo "connected"
    fi
  fi
fi

if [[ $1 == "status" ]]; then
  name=$(name)
  if [[ $name != "" ]]; then
    echo "Connected"
  else
    echo "Disconnected"
  fi
fi

if [[ $1 == "disconnect" ]]; then
  local wifiname="nmcli d | grep wifi | sed 's/^.*wifi.*connected//g' | xargs"
  nmcli con down id "${wifiname}"
fi

radio_status () {
  radio_status=$(nmcli radio wifi)
  if [[ $radio_status == "enabled" ]]; then
    echo "on"
  else
    echo "off"
  fi
}

if [[ $1 == "radio-status" ]]; then
  radio_status
fi

if [[ $1 == "toggle-radio" ]]; then
  stat=$(radio_status)
  if [[ $stat == "on" ]]; then
    nmcli radio wifi off
  else
    nmcli radio wifi on
  fi
fi
