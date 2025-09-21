#!/bin/bash
# Enable the NinjaOne agent systemd service during app install.
# Service name per NinjaOne docs: ninjarmm-agent.service
# https://www.ninjaone.com/docs/endpoint-management/hardware-inventory/linux-devices/
enable_system_service ninjarmm-agent.service
