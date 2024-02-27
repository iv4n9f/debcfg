#!/bin/bash

user=$(whoami)
system=$(uname -n)

echo -e "%{F#0F0}  %{F-} $user %{F#0F0}  %{F-} $system"