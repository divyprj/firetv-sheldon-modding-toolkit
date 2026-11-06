#!/bin/bash
# ==============================================================================
# backup_remote_keys.sh
# Backs up bonded Bluetooth Remote Cryptographic Keys for instant restoration
# ==============================================================================
set -e

BACKUP_DIR="./remote_backup"
mkdir -p "$BACKUP_DIR"

echo "=== Backing up Bluetooth Remote Pairing Keys ==="

if ! adb get-state >/dev/null 2>&1; then
    echo "ERROR: Device not detected via ADB."
    exit 1
fi

echo "Pulling bluedroid configuration..."
adb shell "su -c 'cp /data/misc/bluedroid/bt_config.conf /sdcard/bt_config.conf'"
adb pull /sdcard/bt_config.conf "$BACKUP_DIR/bt_config.conf"
adb shell "rm -f /sdcard/bt_config.conf"

echo "Pulling bluetooth database..."
adb shell "su -c 'cp /data/user_de/0/com.android.bluetooth/databases/bluetooth_db /sdcard/bluetooth_db 2>/dev/null || true'"
adb pull /sdcard/bluetooth_db "$BACKUP_DIR/bluetooth_db" 2>/dev/null || true
adb shell "rm -f /sdcard/bluetooth_db"

echo "=== Backup Complete in $BACKUP_DIR ==="
