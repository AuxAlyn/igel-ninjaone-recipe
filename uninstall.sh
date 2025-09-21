#!/bin/bash
set -euo pipefail
LOGTAG="app-ninjaone-uninstall"
LOGGER="logger -it ${LOGTAG}"

echo "Starting NinjaOne removal..." | $LOGGER

# Stop/disable any service containing 'ninja' in its name
while read -r unit; do
  systemctl disable --now "$unit" || true
  echo "Disabled service: $unit" | $LOGGER
done < <(systemctl list-unit-files | awk 'tolower($1) ~ /ninja/ && $1 ~ /\.service$/ {print $1}')

# Remove the installed package (first matching 'ninja')
PKG="$(dpkg -l | awk '/ninja/{print $2; exit}')"
if [[ -n "$PKG" ]]; then
  dpkg -r "$PKG" || dpkg -P "$PKG" || true
  echo "Removed package: $PKG" | $LOGGER
else
  echo "Package not found; nothing to remove." | $LOGGER
fi

echo "NinjaOne removal complete." | $LOGGER
exit 0
