#!/bin/bash
# ==============================================================================
# debloat_and_block_ota.sh
# Permanent OTA Lockdown & Speed Optimization for Fire OS 7 (sheldon)
# ==============================================================================
set -e

echo "=== Fire OS 7 Debloat & OTA Lockdown ==="

# Check ADB connectivity
if ! adb get-state >/dev/null 2>&1; then
    echo "ERROR: Device not connected via ADB."
    exit 1
fi

echo "[1/4] Disabling Amazon Forced OTA Update Packages..."
OTA_PACKAGES=(
    "com.amazon.device.software.ota"
    "com.amazon.device.software.ota.override"
    "com.amazon.tv.forcedotaupdater.v2"
)

for pkg in "${OTA_PACKAGES[@]}"; do
    echo "  - Disabling $pkg..."
    adb shell "pm disable-user --user 0 $pkg 2>/dev/null || pm disable $pkg 2>/dev/null || true"
done

echo "[2/4] Deploying Magisk Systemless OTA Hosts Block Module..."
adb shell "su -c 'mkdir -p /data/adb/modules/block_ota/system/etc'"

# Write module prop
cat << 'EOF' | adb shell "su -c 'cat > /data/adb/modules/block_ota/module.prop'"
id=block_ota
name=Block Amazon OTA
version=v1.0
versionCode=1
author=Toolkit
description=Systemlessly blocks Amazon OTA servers via /system/etc/hosts
EOF

# Write hosts file
cat << 'EOF' | adb shell "su -c 'cat > /data/adb/modules/block_ota/system/etc/hosts'"
127.0.0.1 localhost
::1 localhost
127.0.0.1 amzdigital-f.akamaihd.net
127.0.0.1 amzdigitaldownloads.edgesuite.net
127.0.0.1 softwareupdates.amazon.com
127.0.0.1 updates.amazon.com
127.0.0.1 fld-dev.amazon.com
EOF

adb shell "su -c 'chmod 644 /data/adb/modules/block_ota/system/etc/hosts && touch /data/adb/modules/block_ota/auto_mount'"

echo "[3/4] Disabling Background Telemetry, Ads & Retail Bloatware..."
BLOAT_PACKAGES=(
    "com.amazon.device.sale.service"
    "com.amazon.kso.blackbird"
    "com.amazon.ftvads.deeplinking"
    "com.amazon.device.crashmanager"
    "com.amazon.shoptv.client"
    "com.amazon.shoptv.firetv.development"
    "com.amazon.whisperplay.contracts"
    "com.amazon.tahoe"
    "com.amazon.bueller.music"
    "com.amazon.bueller.photos"
    "com.amazon.kor.demo"
)

for pkg in "${BLOAT_PACKAGES[@]}"; do
    echo "  - Disabling $pkg..."
    adb shell "pm disable-user --user 0 $pkg 2>/dev/null || true"
done

echo "[4/4] Applying Speed & Animation Optimizations..."
adb shell "settings put global window_animation_scale 0.5"
adb shell "settings put global transition_animation_scale 0.5"
adb shell "settings put global animator_duration_scale 0.5"

echo "=== Optimization Complete! ==="
