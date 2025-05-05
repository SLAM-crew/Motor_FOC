#!/bin/bash

# Check if st-flash is installed
if ! command -v st-flash &> /dev/null; then
    echo "Error: st-flash not found. Install it first (e.g., 'sudo apt install stlink-tools')."
    exit 1
fi

# Get list of connected ST-Link programmers
STLINKS=$(st-info --probe 2>&1 | grep "serial:" | awk '{print $2}')

if [ -z "$STLINKS" ]; then
    echo "No ST-Link detected. Check connection and drivers."
    exit 1
fi

echo "Available ST-Link programmers:"
PS3="Select ST-Link (1-${#STLINKS[@]}): "
select SERIAL in $STLINKS; do
    if [ -n "$SERIAL" ]; then
        break
    else
        echo "Invalid choice. Try again."
    fi
done

# Ask for binary file
read -p "Enter firmware file (e.g., firmware.bin): " FIRMWARE
if [ ! -f "$FIRMWARE" ]; then
    echo "Error: File '$FIRMWARE' not found."
    exit 1
fi

# Flash using selected ST-Link
echo "Flashing with ST-Link (Serial: $SERIAL)..."
st-flash --serial "$SERIAL" write "$FIRMWARE" 0x8000000

if [ $? -eq 0 ]; then
    echo "✅ Flashing successful!"
else
    echo "❌ Flashing failed. Check connections and try again."
fi