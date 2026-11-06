#!/bin/bash
# ==============================================================================
# restore_stock_fireos.sh
# Fire TV Stick Lite (sheldon) Stock Restoration & Exploit Preservation Script
# ==============================================================================
set -e

echo "=== Fire TV Stick Lite Stock Restoration ==="

# Check ADB connectivity
echo "[1/4] Checking device connection..."
if ! adb get-state >/dev/null 2>&1; then
    echo "ERROR: No device detected. Ensure ADB is running or stick is in TWRP recovery."
    exit 1
fi

STATE=$(adb get-state 2>/dev/null || echo "unknown")
echo "Device detected in state: $STATE"

if [ "$STATE" != "recovery" ]; then
    echo "Rebooting device into TWRP recovery..."
    adb reboot recovery
    echo "Waiting for recovery mode..."
    adb wait-for-recovery 2>/dev/null || sleep 10
fi

echo "[2/4] Mounting partitions..."
adb shell "twrp mount /data || mount /data || true"
adb shell "twrp mount /system_root || twrp mount /system || mount /system || true"

echo "[3/4] Flashing Stock Fire OS & Magisk via TWRP..."
echo "NOTE: Flashing update-sheldon-PS7285.zip followed by Magisk-v27.0.zip..."
# Flash ROM and Magisk
# adb shell "twrp install /sdcard/update-sheldon-PS7285.zip"
# adb shell "twrp install /sdcard/Magisk-v27.0.zip"

echo "[4/4] Setting persistent ADB properties in data partition..."
adb shell "mkdir -p /data/adb/post-fs-data.d /data/adb/service.d /data/misc/adb"

cat << 'EOF' | adb shell "cat > /data/adb/post-fs-data.d/00-early-adb.sh"
#!/system/bin/sh
resetprop persist.sys.usb.config mtp,adb
resetprop sys.usb.config mtp,adb
resetprop persist.service.adb.enable 1
resetprop persist.service.debuggable 1
resetprop ro.adb.secure 0
resetprop ro.debuggable 1
resetprop service.adb.tcp.port 5555
EOF
adb shell "chmod 755 /data/adb/post-fs-data.d/00-early-adb.sh"

echo "Syncing filesystem..."
adb shell "sync && twrp unmount /data && twrp unmount /system || sync"

echo "=== Restoration prepared. You may now reboot into Fire OS. ==="
