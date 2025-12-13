#!/bin/bash

# Transit Tracker Hebrew Firmware Build Script
# Builds both 64x32 and 64x64 firmware versions

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Transit Tracker Hebrew Firmware Build Script${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

# Add ESPHome to PATH
export PATH="$PATH:/Users/elam/.local/bin"

# Check if ESPHome is available
if ! command -v esphome &> /dev/null; then
    echo -e "${RED}Error: ESPHome not found in PATH${NC}"
    echo "Please install ESPHome first: pipx install esphome"
    exit 1
fi

echo -e "\n${BLUE}[1/5]${NC} Cleaning old external components..."
rm -rf .esphome/external_components/*/components/transit_tracker

echo -e "${BLUE}[2/5]${NC} Building 64x64 firmware..."
esphome compile transit-tracker-64x64.yaml

echo -e "${BLUE}[3/5]${NC} Copying 64x64 firmware files..."
cp .esphome/build/transit-tracker/.pioenvs/transit-tracker/firmware.bin build/firmware-64x64.bin
cp .esphome/build/transit-tracker/.pioenvs/transit-tracker/firmware.factory.bin build/firmware-64x64.factory.bin
cp .esphome/build/transit-tracker/.pioenvs/transit-tracker/firmware.ota.bin build/firmware-64x64.ota.bin

echo -e "${BLUE}[4/5]${NC} Building 64x32 firmware..."
esphome compile transit-tracker.yaml

echo -e "${BLUE}[5/5]${NC} Copying 64x32 firmware files..."
cp .esphome/build/transit-tracker/.pioenvs/transit-tracker/firmware.bin build/firmware-64x32.bin
cp .esphome/build/transit-tracker/.pioenvs/transit-tracker/firmware.factory.bin build/firmware-64x32.factory.bin
cp .esphome/build/transit-tracker/.pioenvs/transit-tracker/firmware.ota.bin build/firmware-64x32.ota.bin

echo -e "\n${GREEN}✅ Build complete!${NC}"
echo -e "\n${BLUE}Firmware files created:${NC}"
ls -lh build/firmware-*.bin | awk '{print "  " $9 " (" $5 ")"}'

echo -e "\n${BLUE}To flash:${NC}"
echo "  1. Start web server: cd build && python3 -m http.server 8000"
echo "  2. Open http://localhost:8000/flash-64x32.html (or flash-64x64.html)"
echo "  3. Or use CLI: esphome run transit-tracker.yaml"

