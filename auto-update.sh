#!/bin/bash
set -euo pipefail
apt-get update -qq
UPDATES=$(sudo /usr/lib/update-notifier/apt-check 2>&1 | cut -d';' -f1)
if [[ "$UPDATES" -gt 0 ]]; then
    apt-get dist-upgrade -y && apt-get autoremove -y
fi
