#!/bin/bash
set -euo pipefail
sudo apt-get update -qq
UPDATES=$(sudo /usr/lib/update-notifier/apt-check 2>&1 | cut -d';' -f1)
if [[ "$UPDATES" -gt 0 ]]; then
    sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y
fi
