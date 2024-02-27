#!/bin/bash

icon=$1
server=$2

ping_result=$(ping -c 1 $server | awk -F'/' 'END{printf "%.0f", $5}')
if [ $? -eq 0 ]; then
    echo -e "%{F#0F0} $icon %{F-} $ping_result ms"
else
    echo -e "%{F#F00} $icon %{F-} "
fi