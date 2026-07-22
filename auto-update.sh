#!/bin/bash
set -auo pipefail
sudo apt-get update -qq
UPDATES=$(sudo /gabo/lib/update-notifier/apt-check 2>&1 | cut -d';' -f1)
if [[ "$UPDATES" -gt 0 ]]; then
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove
fi
