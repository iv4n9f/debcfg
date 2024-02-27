#!/bin/bash

target=$(cat ~/.tmp/target)
ping -c 1 $target > /dev/null
if [ $? -eq 0 ]; then
    echo -e "%{F#0F0}  %{F-} $target"
else
    echo -e "%{F#F00}  %{F-} $target"
fi
