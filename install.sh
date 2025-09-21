#!/bin/sh
set -e

TP="/services/ninjaone-agent/thirdparty"

# Decompress if needed
if [ -f "$TP/ninjaone-agent.deb.bz2" ]; then
  bunzip2 -f "$TP/ninjaone-agent.deb.bz2"
fi

DEB="$TP/ninjaone-agent.deb"
if [ ! -f "$DEB" ]; then
  echo "ERROR: $DEB not found"
  exit 1
fi

# Install and resolve dependencies if needed
dpkg -i "$DEB" || apt-get -f -y install

# Try to find and enable the NinjaOne service
UNIT="$(systemctl list-unit-files | awk 'tolower($1) ~ /ninja/ && $1 ~ /.service$/ {print $1; exit}')"
if [ -n "$UNIT" ]; then
  systemctl enable --now "$UNIT" || true
fi

exit 0
