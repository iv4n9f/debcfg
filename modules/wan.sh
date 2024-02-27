#!/bin/bash

wan=$(curl -s https://api.ipify.org/?format=json | jq -r '.ip')
echo -e "%{F#0F0}  %{F-} $wan"