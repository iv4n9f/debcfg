#!/bin/bash

date=$(date +"%d/%m/%Y")
timezone=$(date +"%Z")
time=$(date +"%H:%M:%S")

echo -e "%{F#0F0} 󰃮 %{F-} $date %{F#0F0}  %{F-} $time %{F#0F0}  %{F-} $timezone "