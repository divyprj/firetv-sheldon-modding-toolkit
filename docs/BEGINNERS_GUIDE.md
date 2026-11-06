# The Complete Beginner's Guide to Modding Fire TV Stick Lite

Welcome! If you have never modified an Android device, rooted a TV stick, or used the terminal before, **you are in the right place**. 

This guide was written from the ground up for non-technical users. Every step is explained in plain English, with pictures and zero unnecessary jargon.

---

## Table of Contents
1. [Plain English Dictionary (What does all this mean?)](#plain-english-dictionary)
2. [What You Need Before Starting](#what-you-need-before-starting)
3. [Step 1: Check Your USB Cable (The #1 Mistake)](#step-1-check-your-usb-cable)
4. [Step 2: How to Enable Developer Options on Fire TV](#step-2-how-to-enable-developer-options)
5. [Step 3: How to Turn ON ADB Debugging](#step-3-how-to-turn-on-adb-debugging)
6. [Step 4: Find Your Fire TV's IP Address](#step-4-find-your-fire-tvs-ip-address)
7. [Step 5: Connect Your Computer to the TV Stick](#step-5-connect-your-computer-to-the-tv-stick)
8. [Step 6: Authorize Your Computer on the TV Screen](#step-6-authorize-your-computer-on-the-tv-screen)
9. [Step 7: Verify Everything Works](#step-7-verify-everything-works)
10. [Files & Downloads Needed](#files--downloads-needed)

---

## Plain English Dictionary

If these words sound confusing, think of them like this:

| Word | What it Actually Means |
| :--- | :--- |
| **ADB (Android Debug Bridge)** | A digital "remote control wire" that lets your computer send instructions directly to your TV stick over Wi-Fi or USB. |
| **Root (Magisk)** | Gives you "Administrator / Master access" over your own device, so Amazon can't stop you from removing ads or saving RAM. |
| **Bootloader** | The "security guard" that boots up your stick. Unlocking it allows you to run emergency tools and custom software. |
| **TWRP (Recovery)** | A mini emergency rescue screen that lives outside Fire OS. If the stick ever gets stuck or won't start, TWRP lets you fix it. |
| **Bloatware** | Hidden background apps Amazon pre-installed (like shopping trackers and ad engines) that slow your stick down. |
| **OTA (Over-The-Air Update)** | Automatic software updates Amazon sends over the internet. We block these so Amazon doesn't lock your stick back up. |

---

## What You Need Before Starting

1. **Your Amazon Fire TV Stick Lite** (model code `AFTSS`, internal code `sheldon`).
2. **The Fire TV Remote** (with working batteries).
3. **A Computer** (Windows, Mac, or Linux laptop/desktop).
4. **Both devices connected to the SAME Wi-Fi network**.
5. **A Micro-USB Data Cable** (see Step 1 below).

---

## Step 1: Check Your USB Cable (The #1 Mistake)

> [!IMPORTANT]
> More than 80% of beginners fail because they use a **charging-only** cable!

Many micro-USB cables included with vapes, cheap power banks, or electric toothbrushes only have 2 copper wires inside (Power + Ground). They cannot transfer data!

**How to test your cable:**
1. Plug your Fire TV Stick into your computer using your cable.
2. If your computer makes a "device connected" sound or shows a notification, it is a **data cable**.
3. If your computer does completely nothing and only powers on the stick, it is a **charging-only cable**. Swap it for a real smartphone data cable.

---

## Step 2: How to Enable Developer Options

By default, Amazon hides Developer Options. Here is the secret trick to reveal it:

1. Turn on your TV and go to the **Settings** menu (the gear icon ⚙️ on the far right of the home screen).
2. Click on **My Fire TV** (or **Device & Software** on some versions).
3. Click on **About**.
4. Highlight the first item: **Fire TV Stick Lite**.
5. **Press the Center / Select button on your remote 7 times rapidly!**
6. At the bottom of your screen, a small toast message will appear saying:  
   *`"No need, you are already a developer."`*

---

## Step 3: How to Turn ON ADB Debugging

Now that Developer Options is unlocked:

1. Press the **Back button** on your remote once to go back to the **My Fire TV** menu.
2. You will now see a brand new menu item called **Developer Options**! Click on it.
3. Turn **ADB Debugging** to **ON**.
4. Turn **Apps from Unknown Sources** to **ON**.

*(Both must show "ON" so your computer can connect).*

---

## Step 4: Find Your Fire TV's IP Address

Your TV stick has a local network address (like a street address) on your home Wi-Fi:

1. Go to **Settings (⚙️) $\rightarrow$ My Fire TV $\rightarrow$ About**.
2. Scroll down to **Network**.
3. Look at the right side of your screen. You will see:
   * **IP Address:** `192.168.x.x` (for example: `192.168.1.36`)
4. Write this number down! You will need it in the next step.

---

## Step 5: Connect Your Computer to the TV Stick

Make sure your computer and Fire TV are connected to the **same Wi-Fi router**.

1. Open your computer's terminal:
   * **Windows:** Press `Win + R`, type `cmd`, and press Enter.
   * **Mac / Linux:** Open the `Terminal` application.
2. Type the following command (replace `192.168.1.36` with your TV stick's IP from Step 4):
   ```bash
   adb connect 192.168.1.36:5555
   ```
3. Press Enter.

---

## Step 6: Authorize Your Computer on the TV Screen

The moment you press Enter, **look at your television screen**!

A popup window will appear on your TV titled:  
**"Allow USB debugging?"**

1. Use your Fire TV remote to check the box:  
   ☑️ **"Always allow from this computer"**
2. Click **OK**.

> [!WARNING]
> If you don't check the box and click OK on your TV screen with the remote, your computer will say `unauthorized` and cannot send commands.

---

## Step 7: Verify Everything Works

Back on your computer terminal, type:

```bash
adb devices
```

You should see:
```text
List of devices attached
192.168.1.36:5555    device
```

If it says **`device`**, congratulations! 🎉 Your computer is now fully linked to your TV stick, and you are ready to run the automated debloat and modding scripts.

---

## Files & Downloads Needed

All the software tools used in this toolkit are free and open-source:

| Tool | Purpose | Direct Download Link |
| :--- | :--- | :--- |
| **Android Platform Tools (ADB)** | Installs `adb` command line on your PC | [Google Official Platform Tools](https://developer.android.com/tools/releases/platform-tools) |
| **Magisk v27.0** | Provides root access and systemless module support | [Magisk Official Releases](https://github.com/topjohnwu/Magisk/releases) |
| **TWRP Recovery (`sheldon`)** | Custom recovery image for Fire TV Stick Lite | [TWRP Sheldon Thread / Files](https://forum.xda-developers.com/t/unlock-root-twrp-unbrick-fire-tv-stick-lite-3rd-gen-sheldon-p.4439949/) |
| **Stock Fire OS 7.2.8.5** | Clean factory firmware base | [Amazon Official Update Bin](https://www.amazon.com/gp/help/customer/display.html?nodeId=G201497590) |
| **Kamakiri (amonet) Exploit** | Bootrom unlocking scripts and microloader | [Kamakiri Sheldon Release](https://github.com/amonet-kamakiri) |

---

## Next Steps
Now that your stick is connected to ADB:
* Run [`scripts/debloat_and_block_ota.sh`](../scripts/debloat_and_block_ota.sh) to eliminate all ads and speed up your Fire TV.
* Read [`docs/OTA_BLOCKLIST.md`](OTA_LOCKDOWN_GUIDE.md) to make sure Amazon never overwrites your setup.
