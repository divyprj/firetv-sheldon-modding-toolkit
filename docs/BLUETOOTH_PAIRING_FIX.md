# Bluetooth Remote Pairing Deadlock & Stale Cryptographic Key Fix

## The Problem
After restoring a Fire TV Stick from LineageOS / AOSP back to Fire OS 7, the physical remote (`AR`, MAC `28:73:F6:2B:CB:14`) often refuses to pair. 

Symptoms:
* The Fire TV displays the "Searching for your remote..." screen indefinitely.
* Holding the Home button on the remote causes the LED to blink rapidly (or timeout), but the stick never discovers it.
* Manually starting the Bluetooth pairing wizard via ADB displays a spinning wheel with zero discovered devices.

---

## Technical Root Cause: Cryptographic Incompatibility

Bluetooth Low Energy (BLE) bonding relies on Long-Term Keys (LTK), Identity Resolving Keys (IRK), and Connection Signature Resolving Keys (CSRK) stored in `/data/misc/bluedroid/bt_config.conf`.

* **LineageOS 20 (Android 13):** Uses modern Fluoride / Android 13 Bluetooth stack with updated elliptic-curve cryptographic structures and GATT hashes (`gatt_hash_*`).
* **Fire OS 7 (Android 9):** Uses an older Broadcom/MediaTek Bluedroid stack.
* When Android 9 attempts to parse an existing `/data/misc/bluedroid/bt_config.conf` created or touched by Android 13:
  1. The Bluedroid parser encounters unparseable cryptographic attributes.
  2. Bluedroid marks the adapter as bonded with corrupted state, refusing to enter LE scan mode for the bonded MAC address.
  3. The stick enters an unrecoverable pairing deadlock.

---

## Step-by-Step Resolution

### Step 1: Wipe Corrupted Bluetooth Databases in TWRP
Do not perform a full factory wipe (which wastes time re-flashing). Clear only the Bluetooth NVRAM cache:

```bash
# Boot into TWRP
adb reboot recovery
adb wait-for-recovery

# Mount data partition
adb shell twrp mount /data

# Wipe stale configuration and caches
adb shell rm -rf /data/misc/bluedroid/bt_config*
adb shell rm -rf /data/misc/bluetooth/*
adb shell rm -rf /data/user_de/0/com.android.bluetooth/databases/*

# Re-create directory with proper Linux ownership (UID 1002 = bluetooth)
adb shell mkdir -p /data/misc/bluedroid /data/misc/bluetooth /data/user_de/0/com.android.bluetooth/databases
adb shell chown -R 1002:1002 /data/misc/bluedroid /data/misc/bluetooth /data/user_de/0/com.android.bluetooth
adb shell chmod 770 /data/misc/bluedroid /data/misc/bluetooth

# Unmount and reboot to Fire OS
adb shell "sync && twrp unmount /data"
adb reboot
```

### Step 2: Factory Reset the Physical Remote
Clear the remote's internal EEPROM memory so it stops looking for the old Android 13 host:
1. Press and hold **Left (directional circle)** + **Menu ($\equiv$)** + **Back ($\leftarrow$)** simultaneously for **12 seconds**.
2. Release and wait **5 seconds**.
3. Remove the batteries for **10 seconds**, then reinsert them.

### Step 3: Trigger Native Pairing via ADB
Once Fire OS boots:
```bash
# Launch the native Bluetooth Settings Activity directly:
adb shell am start -n com.amazon.tv.settings.v2/.tv.controllers_bluetooth_devices.ControllersAndBluetoothActivity

# Hold the Home button on the remote for 10 seconds.
# When the remote appears in the list on screen, send the Select key:
adb shell input keyevent 66
```

The remote will instantly pair and initialize with full button and microphone support.
