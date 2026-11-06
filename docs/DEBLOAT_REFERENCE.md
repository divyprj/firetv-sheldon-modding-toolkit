# Fire OS 7 Safe Debloat & Telemetry Reference

The Fire TV Stick Lite has only **1 GB of RAM**. Amazon's background services (shopping, crash reporting, ad carousels, and telemetry) consume over 450 MB of memory at idle. 

Disabling these packages frees up significant RAM, keeps CPU temperatures low, and prevents background streaming stutter.

---

## Verified Safe to Disable

| Package Name | Description / Why Disable |
| :--- | :--- |
| `com.amazon.device.sale.service` | Retail sales demo and in-store display service |
| `com.amazon.kso.blackbird` | Sponsored ad banners and home screen video carousels |
| `com.amazon.ftvads.deeplinking` | Ad deep linking and click tracking telemetry |
| `com.amazon.device.crashmanager` | Crash log uploader and continuous metric telemetry |
| `com.amazon.shoptv.client` | Amazon Shopping TV app (runs background sync) |
| `com.amazon.shoptv.firetv.development` | Internal shopping development metrics |
| `com.amazon.whisperplay.contracts` | Local network device discovery daemon (battery/RAM hog) |
| `com.amazon.tahoe` | Amazon screen saver photo stream |
| `com.amazon.bueller.music` | Amazon Music background preload daemon |
| `com.amazon.bueller.photos` | Amazon Photos background daemon |
| `com.amazon.kor.demo` | Retail kiosk mode |
| `com.amazon.tv.oobe` | Out-Of-Box Experience / Initial setup wizard |

---

## Critical Packages (DO NOT DISABLE)

Disabling these will cause bootloops or break core functionality:

| Package Name | Reason |
| :--- | :--- |
| `com.amazon.tv.launcher` | Home screen launcher (unless a custom launcher is installed) |
| `com.amazon.tv.settings.v2` | Main TV settings interface & Bluetooth device pairing |
| `com.amazon.device.lowstoragemonitor` | Disk space alert service |
| `android` / `com.android.systemui` | Android system UI & leanback framework |
| `com.android.bluetooth` | Bluetooth stack (required for remote control) |
| `com.amazon.webview` | Amazon Chromium web runtime (required by streaming apps) |
