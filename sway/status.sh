#!/bin/bash

while true; do
    WIFI_NAME=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 || echo "disconnected")
    SIGNAL=$(nmcli -f IN-USE,SIGNAL dev wifi | grep "*" | awk '{print $2}')

    LOCAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')

    BAT_STATUS=$(cat /sys/class/power_supply/BAT*/status)
    BAT_CAPACITY=$(cat /sys/class/power_supply/BAT*/capacity)
    BAT_ICON=$([ "$BAT_STATUS" = "Charging" ] && echo "⚡" || echo "󰂀")

    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    MEM_USAGE=$(free -m | awk '/Mem:/ {printf "%.1f%%", $3/$2*100}')
    DISK_USAGE=$(df -h / | awk '/\/$/ {print $5}')
    BRIGHTNESS=$(brightnessctl -m | cut -d',' -f4 | tr -d '%')

    VOL=$(amixer get Master | grep -oP '\[\K[^%]*' | head -n1)
    MUTE=$(amixer get Master | grep -o '\[off\]' && echo " " || echo " ")
    BT_DEVICE=$(bluetoothctl devices Connected | cut -d' ' -f3-)
    BT_AUDIO=$(pactl list sinks | grep -A1 "Name: bluez" | grep "Description" | cut -d: -f2- || echo "")

    TEMP=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -n1 | awk '{printf "%.1f°C", $1/1000}')

    echo ": $WIFI_NAME ($SIGNAL%) $LOCAL_IP   󰃚 $BRIGHTNESS%    $BAT_ICON $BAT_CAPACITY%     $CPU_USAGE%   $MEM_USAGE    $DISK_USAGE   $MUTE $VOL% 󰂯 ${BT_DEVICE:--}    $TEMP    $(date +'%Y-%m-%d (%a) %H:%M:%S')"
    sleep 1

done
