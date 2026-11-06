# Two-Tier Amazon OTA Lockdown Strategy

## Overview
Amazon actively pushes silent, forced over-the-air updates to Fire TV devices that overwrite the bootloader (`preloader` and `lk`), patching the `amonet` exploit. 

To permanently neutralize OTA updates without breaking streaming apps or the Amazon Appstore, we implement a **two-tier defense system**.

---

## Tier 1: Android Package Manager Disabling
Using root access via Magisk or ADB, we disable all system packages responsible for downloading, verifying, and staging system updates:

```bash
# Disable standard OTA client
pm disable-user --user 0 com.amazon.device.software.ota

# Disable OTA override service
pm disable-user --user 0 com.amazon.device.software.ota.override

# Disable forced recovery updater
pm disable-user --user 0 com.amazon.tv.forcedotaupdater.v2
```

### Verification:
```bash
adb shell pm list packages -d | grep ota
# Output:
# package:com.amazon.device.software.ota
# package:com.amazon.device.software.ota.override
# package:com.amazon.tv.forcedotaupdater.v2
```

---

## Tier 2: Magisk Systemless DNS Redirection (Hosts)

Even if a background service is re-enabled by an Amazon system component, Tier 2 redirects all Amazon update endpoints to `127.0.0.1` at the network socket layer.

### Blocked Hostnames:
| Hostname | Role |
| :--- | :--- |
| `amzdigital-f.akamaihd.net` | Akamai CDN endpoint for Amazon binary OTA downloads |
| `amzdigitaldownloads.edgesuite.net` | EdgeSuite CDN for Fire OS recovery packages |
| `softwareupdates.amazon.com` | Amazon primary software update server |
| `updates.amazon.com` | Secondary update server |
| `fld-dev.amazon.com` | Device software telemetry and staging |

### Magisk Module Deployment:
Placed at `/data/adb/modules/block_ota/system/etc/hosts`:
```text
127.0.0.1 localhost
::1 localhost
127.0.0.1 amzdigital-f.akamaihd.net
127.0.0.1 amzdigitaldownloads.edgesuite.net
127.0.0.1 softwareupdates.amazon.com
127.0.0.1 updates.amazon.com
127.0.0.1 fld-dev.amazon.com
```

This guarantees 100% exploit preservation across all boots and network environments.
