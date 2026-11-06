#!/bin/bash
# ==============================================================================
# fix_bluetooth_pairing.sh
# Resolves Bluetooth Remote Pairing Deadlocks between Android 13 & Android 9
# ==============================================================================
set -e

echo "=== Fire TV Remote Pairing Deadlock Resolution ==="

echo "Waiting for device in TWRP recovery..."
adb wait-for-recovery 2>/dev/null || adb wait-for-device

echo "Mounting data partition..."
adb shell "twrp mount /data || mount /data || true"

echo "Wiping stale BLE bonding keys and corrupted GATT caches..."
adb shell "rm -rf /data/misc/bluedroid/bt_config* 2>/dev/null || true"
adb shell "rm -rf /data/misc/bluetooth/* 2>/dev/null || true"
adb shell "rm -rf /data/user_de/0/com.android.bluetooth/databases/* 2>/dev/null || true"

echo "Re-creating clean Bluetooth storage structure..."
adb shell "mkdir -p /data/misc/bluedroid /data/misc/bluetooth /data/user_de/0/com.android.bluetooth/databases"
adb shell "chown -R 1002:1002 /data/misc/bluedroid /data/misc/bluetooth /data/user_de/0/com.android.bluetooth"
adb shell "chmod 770 /data/misc/bluedroid /data/misc/bluetooth"

echo "Syncing filesystem..."
adb shell "sync && twrp unmount /data || sync"

echo "Rebooting into Fire OS..."
adb reboot

echo ""
echo "=== NEXT STEPS ONCE FIRE OS BOOTS ==="
echo "1. Run the native pairing activity via ADB:"
echo "   adb shell am start -n com.amazon.tv.settings.v2/.tv.controllers_bluetooth_devices.ControllersAndBluetoothActivity"
echo "2. Hold HOME on physical remote for 10 seconds until discovery."
echo "3. Press ENTER via ADB to confirm:"
echo "   adb shell input keyevent 66"
