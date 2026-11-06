# The 360p Streaming Downscale Problem on Android 13

## Executive Summary
Flashing custom AOSP / LineageOS 20 (Android 13) onto the Fire TV Stick Lite (`sheldon`) introduces severe video playback degradation. Applications such as MovieBoxTV, Netflix, Hotstar, and Prime Video fall back to low-resolution software streams (360p–480p) despite a 1080p display and gigabit internet.

This document outlines the root architectural cause and why staying on Fire OS 7 (Android 9 base) is mandatory for hardware-accelerated playback.

---

## Technical Root Cause Analysis

### 1. Legacy 32-bit MediaTek OpenMAX (OMX) Drivers
MediaTek provided proprietary hardware video decoders for the MT8695 chip compiled strictly for:
* **Target Architecture:** 32-bit ARM (`armeabi-v7a`)
* **Android Framework:** Android 9.0 Pie (API Level 28)
* **HAL Standard:** OpenMAX Integration Layer (`OMX.MTK.VIDEO.DECODER.*`)

### 2. Android 13 Treble & Codec2 Deprecation
Beginning in Android 12 and strictly enforced in Android 13:
* Google deprecated OpenMAX (OMX) in favor of **Codec2 (`c2.*`)**.
* Android 13 frameworks enforce 64-bit HAL interfaces or strict HIDL/AIDL Treble wrappers (`android.hardware.media.c2`).
* When LineageOS 20 runs on MT8695, it relies on an unstable shim layer to bridge legacy 32-bit Android 9 OMX blobs to Android 13's 64-bit media service.

### 3. MediaCodec Capability Negotiation Failure
When modern streaming applications query `MediaCodecList`:
1. The app requests a hardware-accelerated H.264 / H.265 / VP9 decoder with DRM profile security (Widevine L1/L3).
2. The legacy OMX wrapper crashes, returns `OMX_ErrorInsufficientResources`, or fails color format negotiation (`COLOR_FormatYUV420SemiPlanar`).
3. Rather than crashing the app, the streaming player falls back to:
   * Google's software decoder: `OMX.google.h264.decoder` (or `c2.android.avc.decoder`).
   * Because the quad-core Cortex-A53 cannot decode 1080p 60fps in pure software without 100% CPU saturation, adaptive bitrate algorithms immediately throttle the stream down to 360p/480p.

---

## Comparison Table

| Feature | LineageOS 20 (Android 13) | Stock Fire OS 7 (Android 9) |
| :--- | :--- | :--- |
| **Hardware Video Decode (AVC/HEVC)** | Broken / Wrapper failures | **Full 1080p 60fps hardware acceleration** |
| **Streaming Quality (MovieBox / Netflix)** | Locked to 360p/480p fallback | **Native Crisp 1080p** |
| **Audio Bitstream (Dolby Digital / Atmos)** | Stereo PCM only | **Full 5.1/7.1 Surround Passthrough** |
| **CPU Usage during 1080p playback** | 95%–100% (Throttling / Stutter) | **12%–20% (Cool & Fluid)** |
| **Bluetooth Remote Voice Search** | Limited / Broken audio HAL | **Fully Functional** |

---

## Conclusion
For media center devices, hardware video decoding is the single most critical subsystem. Stock Fire OS 7.2.8.5 with TWRP, Magisk, and complete debloat provides the exact sweet spot: modern Magisk root flexibility with flawless 1080p hardware decoders.
