#!/bin/sh
set -e

# Stop/disable any service with 'ninja' in the name
systemctl list-unit-files | awk 'tolower($1) ~ /ninja/ && $1 ~ /.service$/' | while read -r UNIT _; do
  systemctl disable --now "$UNIT" || true
done

# Remove the installed package (first match)
PKG="$(dpkg -l | awk '/ninja/{print $2; exit}')"
if [ -n "$PKG" ]; then
  dpkg -r "$PKG" || dpkg -P "$PKG" || true
fi

exit 0

