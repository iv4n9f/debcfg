#!/bin/bash

interface=$1

if [[ -n $interface ]]; then
  ip=$(ip -4 addr show dev $interface 2> /dev/null | awk '/inet /{print $2}' | cut -d "/" -f 1)
  if [[ -n $ip ]]; then
    echo -e "%{F#0F0} 󰲝 %{F-}${interface^^} $ip"
  else
    echo -e "%{F#F00} 󰲝 %{F-}${interface^^} $ip"
  fi
  echo -e "%{F#F00} 󰲝 %{F-}${interface^^} $ip"
else
  echo -e "%{F#F00} 󰲝 %{F-}${interface^^} N/A"
fi