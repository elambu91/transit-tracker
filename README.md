# Transit Tracker - Hebrew/RTL Firmware

Custom firmware for the [Transit Tracker](https://transit-tracker.eastsideurbanism.org/) project with Hebrew language and Right-to-Left (RTL) text display support.

## About This Project

This is a fork of the Transit Tracker project that adds:
- **Hebrew font support** - Display Hebrew characters on LED matrix
- **RTL (Right-to-Left) text rendering** - Proper text direction for Hebrew
- **Hebrew status messages** - All system messages translated to Hebrew
- **Israeli public transit integration** - Works with Israeli bus data

## Project Components

### 1. Transit Tracker Firmware (You are here)
**Repository:** [elambu91/transit-tracker](https://github.com/elambu91/transit-tracker)

This repository contains the firmware configuration and build system for flashing your ESP32 device with Hebrew support.

### 2. ESPHome Transit Tracker Component  
**Repository:** [elambu91/esphome-transit-tracker](https://github.com/elambu91/esphome-transit-tracker)

The ESPHome custom component that handles the display rendering with RTL support. This is automatically referenced by the firmware - you don't need to clone it separately.

### 3. Israeli Bus API Server
**Repository:** [elambu91/israeli-bus](https://github.com/elambu91/israeli-bus)

Backend server that provides real-time Israeli bus schedule data. Required if you want to display Israeli bus arrivals.

## Quick Start - Flashing Your Device

### Prerequisites

- **Hardware:** ESP32-S3 with HUB75 LED matrix (see [Transit Tracker build guide](https://transit-tracker.eastsideurbanism.org/) for parts)
- **Computer:** macOS, Linux, or Windows with Chrome/Edge browser
- **Python 3.13** (for building firmware yourself)

### Option 1: Flash Using Pre-Built Firmware (Easiest)

1. **Clone this repository:**

```bash
git clone https://github.com/elambu91/transit-tracker
cd transit-tracker/firmware/build
```

2. **Start the web flasher:**

```bash
python3 -m http.server 8000
```

3. **Open the flasher in Chrome or Edge:**
   - For 64x32 displays: http://localhost:8000/flash-64x32.html
   - For 64x64 displays: http://localhost:8000/flash-64x64.html

4. **Connect your ESP32 via USB** and click "Install"

5. **Select your device** from the serial port dialog

6. **Wait for flashing to complete** (2-3 minutes)

### Option 2: Build and Flash Custom Firmware

If you want to modify the configuration (fonts, settings, etc.):

1. **Clone this repository:**

```bash
git clone https://github.com/elambu91/transit-tracker
cd transit-tracker/firmware
```

2. **Install ESPHome:**

```bash
brew install pipx
PIPX_DEFAULT_PYTHON=/opt/homebrew/bin/python3.13 pipx install esphome==2025.8.0
```

3. **Customize the configuration (optional):**

Edit `transit-tracker.yaml` or `transit-tracker-64x64.yaml`:
- Change font settings
- Adjust display brightness
- Modify time zone
- Add/remove glyphs

4. **Build the firmware:**

```bash
./build.sh
```

This will:
- Download your forked ESPHome component with RTL support
- Compile firmware for both display sizes
- Generate `.bin` files in the `build/` directory

5. **Flash using the web flasher** (see Option 1, step 2-6)

   OR flash via ESPHome CLI:

```bash
export PATH="$PATH:/Users/$USER/.local/bin"
esphome run transit-tracker.yaml  # For 64x32
# or
esphome run transit-tracker-64x64.yaml  # For 64x64
```

## After Flashing - Configure Your Display

### Connect to WiFi & Configure Routes
**Using Official Transit Tracker Configurator**


1. Visit the [official Transit Tracker configurator](https://transit-tracker.eastsideurbanism.org/configurator)
2. Connect your device via USB
3. **MAKE SURE YOU SKIP INITIAL CONFIGURATION!!!** You already did that by using this firmware
4. Connect your device to your wifi
5. Set the API url to your locally/remotely hosted server (see top of readme for server repo)
6. Select stops and routes from the map
7. in advanced settings, write your time units in hebrew (דקות or דק or just an apostrophe ')
8. Push configuration to your device

## Features

### Hebrew Display
- **Font:** ChavaRegular with full Hebrew alphabet support
- **Size:** 8pt (optimized for LED matrix readability)
- **Glyphs:** Hebrew letters, numbers, arrows (←↑→↓↔↕), punctuation
- **RTL Mode:** Enabled by default - text flows right-to-left

### Status Messages (in Hebrew)
- ממתין לרשת - Waiting for network
- ממתין לסנכרון שעה - Waiting for time sync
- טוען... - Loading...
- אין הגעות קרובות - No upcoming arrivals
- שגיאה בטעינת לוח זמנים - Error loading schedule

### Supported Display Configurations
- **64x32** (2x 64x32 panels = 128x32 total)
- **64x64** (2x 64x64 panels = 128x64 total)

## Configuration Files

### Main Configuration Files

- `firmware/transit-tracker.yaml` - 64x32 display configuration
- `firmware/transit-tracker-64x64.yaml` - 64x64 display configuration
- `firmware/fonts/ChavaRegular.ttf` - Hebrew font file
- `firmware/build.sh` - Automated build script

### Key Configuration Options

```yaml
font:
  - file: "fonts/ChavaRegular.ttf"
    size: 8  # Font size
    glyphs:  # Supported characters
      - abcdefghijklmnopqrstuvwxyz...
      - אבגדהוזחטיכךלמםנןסעפףצץקרשת  # Hebrew

transit_tracker:
  id: tracker
  rtl_mode: true  # Enable RTL text direction
```

## Updating Firmware (OTA)

After initial flashing, you can update over-the-air:

1. Go to http://transit-tracker.local
2. Click "OTA Update"
3. Upload the appropriate `.ota.bin` file from `firmware/build/`

## Troubleshooting

### Hebrew text not displaying
- Make sure you flashed the firmware from this repository (not the original)
- Check that you built with the latest version of your forked component

### Text is thin/hard to read
- The ChavaRegular font at size 8 is optimized for this display
- You can try different fonts by editing the YAML and rebuilding

### Web flasher doesn't work
- Make sure you run the server! (Just opening the http file is not enough)
- Use Chrome or Edge (Firefox/Safari don't support Web Serial API)
- Make sure your USB cable supports data transfer (not just power)
- Try a different USB port

### Build errors
- Make sure you're using ESPHome 2025.8.0
- Check that Python 3.13 is installed
- Delete `.esphome/` directory and rebuild

## Building Your Own Israeli Transit Tracker

Want the complete Israeli Transit Tracker? Follow these steps:

### Step 1: Order Hardware

Visit the [Transit Tracker build guide](https://transit-tracker.eastsideurbanism.org/) for the complete parts list. You'll need:
- ESP32-S3 development board
- HUB75 LED matrix panels (64x32 or 64x64)
- Power supply (5V, 4A minimum)
- Enclosure (optional, 3D printable files available)

### Step 2: Flash Firmware (You are here!)

Follow the "Quick Start" instructions above to flash your device.

### Step 3: Set Up API Server

Clone and run the Israeli Bus server on a Raspberry Pi or always-on computer:

```bash
git clone https://github.com/elambu91/israeli-bus
cd israeli-bus
pip install -r requirements.txt
python server_http.py
```

See the [Israeli Bus repo](https://github.com/elambu91/israeli-bus) for detailed setup instructions.

### Step 4: Configure Display

Point your Transit Tracker to your API server and select your stops/routes (see "After Flashing" section above).

## Credits

- **Original Transit Tracker:** [Eastside Urbanism](https://transit-tracker.eastsideurbanism.org/)
- **Hebrew/RTL Support:** This fork
- **ChavaRegular Font:** [Chava Font](https://github.com/hadassa/chava)
- **Israeli Bus Data:** [israel-bus-cli](https://pypi.org/project/israel-bus-cli/)

## License

This project maintains compatibility with the original Transit Tracker project's licensing.
