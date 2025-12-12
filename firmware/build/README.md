# Transit Tracker Custom Firmware - Hebrew Support

## What Was Done

This firmware has been customized with:
1. **Hebrew Font Support**: Changed from Pixolletta8px to ChavaRegular font with Hebrew character support
2. **RTL Mode Switch**: Added a configuration switch for RTL (Right-to-Left) mode
3. **ESPHome 2025.8.0**: Built with compatible ESPHome version

## Build Output

All firmware files are in `firmware/build/`:

### 64x32 Display (128x32 total with 2 panels)
- `firmware-64x32.factory.bin` - Full firmware for first-time flash
- `firmware-64x32.ota.bin` - For OTA updates
- `manifest-64x32.json` - Web flasher manifest
- `flash-64x32.html` - Web flasher page

### 64x64 Display (128x64 total with 2 panels)
- `firmware-64x64.factory.bin` - Full firmware for first-time flash
- `firmware-64x64.ota.bin` - For OTA updates
- `manifest-64x64.json` - Web flasher manifest
- `flash-64x64.html` - Web flasher page

## How to Flash

### Method 1: Web Flasher (Recommended for First Flash)

1. **Open the appropriate HTML file in Chrome or Edge:**
   - For 64x32 display: Open `firmware/build/flash-64x32.html`
   - For 64x64 display: Open `firmware/build/flash-64x64.html`

2. **Connect your device** via USB

3. **Click the "Install" button** on the web page

4. **Select your device** from the serial port dialog

5. **Wait for flashing to complete** (takes 2-3 minutes)

### Method 2: ESPHome CLI

```bash
cd firmware
export PATH="$PATH:~/.local/bin"

# For 64x32:
esphome run transit-tracker.yaml

# For 64x64:
esphome run transit-tracker-64x64.yaml
```

### Method 3: OTA Update (For Already Flashed Devices)

1. Navigate to your device's web interface (http://transit-tracker.local or its IP)
2. Go to the Update section
3. Upload the appropriate `.ota.bin` file:
   - `firmware-64x32.ota.bin` for 64x32 displays
   - `firmware-64x64.ota.bin` for 64x64 displays

## After Flashing

1. **Device boots** and creates WiFi access point "transit-tracker"
2. **Connect to the AP** and configure your WiFi
3. **Access web interface** at http://transit-tracker.local
4. **Configure your transit routes** through the web UI
5. **Enable RTL Mode** if needed (found in configuration switches)

## Configuration

### Hebrew Support
The firmware now uses the ChavaRegular font which includes all Hebrew letters (א-ת). Hebrew text will display correctly on the LED matrix.

### RTL Mode
An "RTL Mode" switch has been added to the configuration. This switch is available in:
- Home Assistant (if integrated)
- The device's web interface
- ESPHome API

**Note**: The RTL switch currently serves as a configuration flag. Full RTL text layout (reversing text direction, right-aligning route names, left-aligning times) requires modifications to the external `esphome-transit-tracker` component, which can be done as a future enhancement.

## Rebuilding

To rebuild the firmware after making changes:

```bash
cd firmware
export PATH="$PATH:~/.local/bin"

# Rebuild 64x32:
esphome compile transit-tracker.yaml

# Rebuild 64x64:
esphome compile transit-tracker-64x64.yaml

# Copy new binaries:
cp .esphome/build/transit-tracker/.pioenvs/transit-tracker/firmware*.bin build/
```

## Technical Details

- **ESPHome Version**: 2025.8.0
- **Font**: ChavaRegular.ttf (Hebrew + Latin support)
- **Hebrew Characters**: א-ת (all 22 Hebrew letters plus final forms)
- **Compatible Chips**: ESP32-S3
- **Serial RPC**: Included (compatible with web configurator over USB)

## Troubleshooting

### Web flasher doesn't work
- Make sure you're using Chrome or Edge (Firefox/Safari don't support Web Serial)
- Check USB cable supports data transfer (not just power)

### Device won't connect to WiFi
- Use the captive portal that appears when connecting to "transit-tracker" AP
- Default password: "hunter2hunter2"

### Hebrew characters don't display
- Verify you flashed the correct firmware
- Check that your transit data source provides Hebrew text

### RTL mode doesn't reverse text
- The RTL switch is currently a configuration flag
- Full RTL rendering requires component-level changes (future enhancement)

## Next Steps for Full RTL Support

To implement complete RTL text rendering:
1. Fork the `esphome-transit-tracker` component
2. Modify the `draw_schedule()` method to detect RTL mode
3. Implement reversed text alignment and positioning
4. Update YAML to use forked component

