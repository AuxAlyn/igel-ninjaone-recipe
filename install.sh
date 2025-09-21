#!/bin/bash
set -euo pipefail
LOGTAG="app-ninjaone-install"
LOGGER="logger -it ${LOGTAG}"

echo "Starting NinjaOne install..." | $LOGGER

# App Creator extracts uploaded files into /services/<app-id>/thirdparty/
TP="/services/ninjaone-agent/thirdparty"

# Decompress the uploaded .deb if it is still bzip2 compressed
if [[ -f "$TP/ninjaone-agent.deb.bz2" ]]; then
  bunzip2 -f "$TP/ninjaone-agent.deb.bz2"
fi

DEB="$TP/ninjaone-agent.deb"

if [[ ! -f "$DEB" ]]; then
  echo "ERROR: $DEB not found. Ensure you uploaded ninjaone-agent.deb.bz2 in 'Provide Files'." | $LOGGER
  exit 1
fi

# Install the .deb; resolve deps if needed
dpkg -i "$DEB" || apt-get -f -y install

# Try to find and enable the NinjaOne systemd unit
UNIT="$(systemctl list-unit-files | awk 'tolower($1) ~ /ninja/ && $1 ~ /\.service$/ {print $1; exit}')"
if [[ -n "$UNIT" ]]; then
  systemctl enable --now "$UNIT" || true
  echo "Enabled service: $UNIT" | $LOGGER
else
  echo "WARNING: Could not detect NinjaOne service unit. Verify package contents." | $LOGGER
fi

echo "NinjaOne install complete." | $LOGGER
exit 0
