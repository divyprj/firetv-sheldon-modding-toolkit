# Fire TV Stick Lite (`sheldon`) Complete Modding, Rooting & Restoration Toolkit

[![Platform](https://img.shields.io/badge/Device-Fire%20TV%20Stick%20Lite%20(AFTSS)-orange.svg)](https://en.wikipedia.org/wiki/Amazon_Fire_TV)
[![SoC](https://img.shields.io/badge/SoC-MediaTek%20MT8695D-blue.svg)](https://www.mediatek.com/)
[![Recovery](https://img.shields.io/badge/Recovery-TWRP%203.6.1_9--0-red.svg)](https://twrp.me/)
[![Root](https://img.shields.io/badge/Root-Magisk%20v27.0-green.svg)](https://github.com/topjohnwu/Magisk)
[![Firmware](https://img.shields.io/badge/Firmware-Fire%20OS%207.2.8.5%20(Android%209)-lightgrey.svg)](https://amazon.com)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

A battle-tested, professional engineering toolkit and technical reference guide for unlocking, flashing, rooting, debloating, and permanently locking down the **Amazon Fire TV Stick Lite** (model code **`AFTSS`**, codename **`sheldon`**).

> [!TIP]
> 🐣 **New to modding or non-technical? Start with our [Beginner's Guide](docs/BEGINNERS_GUIDE.md)!**  
> It explains everything in plain English: how to test your USB cable, reveal hidden Developer Options by tapping 7 times, enable ADB debugging, connect over Wi-Fi, and accept the on-screen prompt with your remote.

---

## 🚀 Quick Start for Beginners

If you just want to speed up your Fire TV and remove all ads without reading complex code:

1. **Follow the [Beginner's Guide](docs/BEGINNERS_GUIDE.md)** to turn on **ADB Debugging** on your TV stick.
2. **Connect your computer** to your Fire TV over your home Wi-Fi:
   ```bash
   adb connect <YOUR_FIRE_TV_IP>:5555
   ```
3. **Run the 1-Click Debloat Script**:
   ```bash
   ./scripts/debloat_and_block_ota.sh
   ```
*That's it! Your stick will instantly drop idle RAM usage from ~850MB to ~350MB, kill background ad engines, and block Amazon from pushing updates.*

---

## Table of Contents
1. [Beginner's Guide (Start Here)](docs/BEGINNERS_GUIDE.md)
2. [Device Specifications](#device-specifications)
3. [Required Files & Download Sources](#required-files--download-sources)
4. [Why Stock Fire OS 7 Over LineageOS 20?](#why-stock-fire-os-7-over-lineageos-20)
5. [Bootrom Exploit & amonet Architecture](#bootrom-exploit--amonet-architecture)
6. [Permanent TWRP Recovery](#permanent-twrp-recovery)
7. [Magisk 27.0 Root & Silent Superuser](#magisk-270-root--silent-superuser)
8. [Bluetooth Remote Pairing Deadlock Resolution](#bluetooth-remote-pairing-deadlock-resolution)
9. [Permanent Two-Tier OTA Lockdown](#permanent-two-tier-ota-lockdown)
10. [Telemetry Decimation & Speed Debloat](#telemetry-decimation--speed-debloat)
11. [Automated Scripts Directory](#automated-scripts-directory)
12. [Proof & Evidence Gallery](#proof--evidence-gallery)

---

## Required Files & Download Sources

Here are the exact files and direct links you need:

| File / Component | Purpose | Official Direct Source |
| :--- | :--- | :--- |
| **Google Platform-Tools** | Contains `adb` & `fastboot` command line | [Google Developers Official](https://developer.android.com/tools/releases/platform-tools) |
| **Magisk v27.0** | Systemless root zip for TWRP installation | [Magisk GitHub Releases](https://github.com/topjohnwu/Magisk/releases) |
| **TWRP 3.6.1_9-0 (`sheldon`)** | Custom recovery image | [XDA Sheldon Thread](https://forum.xda-developers.com/t/unlock-root-twrp-unbrick-fire-tv-stick-lite-3rd-gen-sheldon-p.4439949/) |
| **Fire OS 7.2.8.5 Stock ROM** | Clean factory firmware base | [Amazon Software Updates](https://www.amazon.com/gp/help/customer/display.html?nodeId=G201497590) |
| **Kamakiri (amonet) Exploit** | BootROM unlock payload & python tools | [Kamakiri Sheldon Repo](https://github.com/amonet-kamakiri) |


---

## Device Specifications

| Attribute | Specification |
| :--- | :--- |
| **Model Code** | Amazon AFTSS |
| **Internal Codename** | `sheldon` |
| **Processor (SoC)** | MediaTek MT8695D (Quad-Core ARM Cortex-A53 @ 1.7 GHz) |
| **GPU** | Imagination PowerVR GE8300 |
| **RAM** | 1 GB LPDDR4 |
| **Internal Storage** | 8 GB eMMC 5.1 |
| **OS Base** | Fire OS 7.2.8.5 (`PS7285/2880`, 32-bit userland on 64-bit Linux kernel 4.4.146) |
| **Bootrom Exploit** | `amonet` (Kamakiri microloader via MediaTek BootROM SLA/DAA handshake) |
| **Recovery** | Custom TWRP 3.6.1_9-0 (`twrp-sheldon.img`) |

---

## Why Stock Fire OS 7 Over LineageOS 20?

A common objective for enthusiasts is flashing custom AOSP / LineageOS (such as LineageOS 20 / Android 13). However, on the **MediaTek MT8695**, doing so causes critical regressions:

1. **The 360p Streaming Fallback:**
   * MediaTek only released proprietary OpenMAX (`OMX.MTK.VIDEO.DECODER.*`) video decoding HAL blobs compiled for **Android 9 (API 28, 32-bit)**.
   * On Android 13 (API 33), modern streaming applications (MovieBox, Netflix, Prime Video) fail hardware codec capability negotiation and gracefully degrade to software downscaled 360p/480p mobile streams.
2. **Audio Stutter & Passthrough Issues:**
   * Proprietary Dolby Audio / Atmos audio HALs are strictly coupled to Fire OS system services.
3. **The Solution:**
   * Run **Stock Fire OS 7.2.8.5** with TWRP, Magisk 27.0 root, complete background debloat, and permanent OTA blockers. This provides **native 1080p hardware-accelerated video playback** and full Bluetooth remote functionality with **zero Amazon bloat or telemetry**.

*(For a full technical deep dive, see [docs/CODEC_360P_ANALYSIS.md](docs/CODEC_360P_ANALYSIS.md)).*

---

## Bootrom Exploit & amonet Architecture

The Fire TV Stick Lite is permanently bootloader-unlocked via the `amonet` (Kamakiri) hardware microloader exploit:

```
[Power On] 
    │
    ▼
[MediaTek MT8695 BootROM] ──(Hardware Testpoint Short)──► [BROM Handshake via /dev/ttyACM0]
    │                                                                   │
    ▼                                                                   ▼
[Stock Preloader] (Bypassed)                              [Injected Microloader / Payload]
                                                                        │
                                                                        ▼
                                                          [Custom LK / Fastboot / TWRP]
```

### Critical Exploit Preservation Rule:
> [!WARNING]
> When flashing stock ROMs or custom packages in TWRP, **NEVER** overwrite the following partitions:
> - `lk` (Little Kernel)
> - `preloader`
> - `tz` (TrustZone)
> 
> Overwriting these partitions restores Amazon's signed bootloader and **permanently bricks or locks** the bootloader. Our provided flashing scripts automatically patch and protect these partitions.

---

## Permanent TWRP Recovery

TWRP 3.6.1_9-0 is installed to the `/recovery` partition. 

### Booting into TWRP:
* **Via ADB (when Fire OS is running):**
  ```bash
  adb reboot recovery
  ```
* **Via Hardware Bootrom (Fastboot/BROM):**
  Using the `boot-recovery.sh` tool in `kamakiri/` via `handshake2.py FACTORYM`.

---

## Magisk 27.0 Root & Silent Superuser

Root access is maintained via Magisk 27.0 injected into the boot image. 

### Silent Root Configuration for ADB Shell (UID 2000)
To prevent ADB commands from stalling on root prompts during background automations, we configure Magisk's internal SQLite policy database directly:

```bash
# In TWRP or Root Shell:
sqlite3 /data/adb/magisk.db "INSERT OR REPLACE INTO policies (uid, policy, until, logging, notification) VALUES (2000, 2, 0, 1, 0);"
sqlite3 /data/adb/magisk.db "INSERT OR REPLACE INTO settings (key, value) VALUES ('su_auto_response', 1);"
```
* **`policy=2`:** Permanently Grant Root.
* **`su_auto_response=1`:** Automatically grant without on-screen UI prompt.

---

## Bluetooth Remote Pairing Deadlock Resolution

When restoring from custom ROMs (e.g. LineageOS) back to Fire OS, the Alexa Voice Remote (`AR`, MAC `28:73:F6:2B:CB:14`) often enters a permanent pairing loop where the TV searches for remotes indefinitely.

### Root Cause:
LineageOS (Android 13) writes newer cryptographic BLE Long-Term Keys (LTK) into `/data/misc/bluedroid/bt_config.conf`. When Fire OS 7 (Android 9) reads these keys, its older Bluedroid stack fails the BLE cryptographic handshake.

### The Fix:
```bash
# In TWRP:
twrp mount /data
rm -rf /data/misc/bluedroid/bt_config*
rm -rf /data/misc/bluetooth/gatt_cache_*
rm -rf /data/user_de/0/com.android.bluetooth/databases/*
sync
```
Once cleared, trigger the native pairing wizard via ADB:
```bash
adb shell am start -n com.amazon.tv.settings.v2/.tv.controllers_bluetooth_devices.ControllersAndBluetoothActivity
# When the remote appears in the list, confirm:
adb shell input keyevent 66
```

*(See [docs/BLUETOOTH_PAIRING_FIX.md](docs/BLUETOOTH_PAIRING_FIX.md) for full instructions).*

---

## Permanent Two-Tier OTA Lockdown

Amazon aggressively attempts to patch bootloader vulnerabilities via forced background OTA updates. We implement a **dual-tier defense**:

### Tier 1: Android Package Manager Disabling
```bash
pm disable-user --user 0 com.amazon.device.software.ota
pm disable-user --user 0 com.amazon.device.software.ota.override
pm disable-user --user 0 com.amazon.tv.forcedotaupdater.v2
```

### Tier 2: Magisk Hosts Systemless DNS Redirection
Deployed as a permanent boot module in `/data/adb/modules/block_ota/system/etc/hosts`:
```text
127.0.0.1 amzdigital-f.akamaihd.net
127.0.0.1 amzdigitaldownloads.edgesuite.net
127.0.0.1 softwareupdates.amazon.com
127.0.0.1 updates.amazon.com
127.0.0.1 fld-dev.amazon.com
```

---

## Telemetry Decimation & Speed Debloat

Over 25 Amazon telemetry, advertisement injection, and retail demo packages are disabled to free up RAM on the 1 GB hardware:

```bash
# Key packages disabled:
com.amazon.device.sale.service      # Retail sales demo
com.amazon.kso.blackbird            # Home screen ads engine
com.amazon.ftvads.deeplinking       # Ad deep link handler
com.amazon.device.crashmanager      # Diagnostic crash reporting
com.amazon.shoptv.*                 # Shopping TV telemetry
```

### Window & Animation Speed Optimizations:
```bash
settings put global window_animation_scale 0.5
settings put global transition_animation_scale 0.5
settings put global animator_duration_scale 0.5
```

---

## Automated Scripts Directory

* [`scripts/restore_stock_fireos.sh`](scripts/restore_stock_fireos.sh): Complete root-executable script to flash stock Fire OS, inject TWRP preservation, and patch boot.
* [`scripts/debloat_and_block_ota.sh`](scripts/debloat_and_block_ota.sh): Disables telemetry packages and deploys the permanent OTA hosts block module.
* [`scripts/fix_bluetooth_pairing.sh`](scripts/fix_bluetooth_pairing.sh): Resolves remote pairing deadlocks by clearing stale cryptographic caches in TWRP.
* [`scripts/backup_remote_keys.sh`](scripts/backup_remote_keys.sh): Dumps bonded Bluetooth remote keys for instant zero-interaction re-pairing.

---

## Proof & Evidence Gallery

| Evidence | Description | Artifact |
| :--- | :--- | :--- |
| **Remote Paired** | Physical Alexa Voice Remote operational in Fire OS 7 | [screen_paired_success.png](proofs/screen_paired_success.png) |
| **Remote Details** | Hardware MAC (`28:73:F6:2B:CB:14`), Firmware & Battery verified | [screen_remote_detail.png](proofs/screen_remote_detail.png) |
| **Magisk Root** | Magisk 27.0 active with su binary operational | [screen_magisk.png](proofs/screen_magisk.png) |
| **Silent Superuser** | ADB granted permanent root rights in policy database | [screen_su_section.png](proofs/screen_su_section.png) |
| **Wi-Fi Connectivity** | High-speed 5 GHz connection established | [screen_connected.png](proofs/screen_connected.png) |

---

## License

This project is licensed under the [MIT License](LICENSE).
