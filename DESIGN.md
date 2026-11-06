# Design System: Zenith TV OS (10-Foot Living Room Interface)

## 1. Visual Theme & Atmosphere
A restrained, cinematic, low-cognitive-load interface engineered specifically for 10-foot viewing distances and physical D-pad remote navigation. The atmosphere fuses the quiet restraint of a museum gallery with the physical depth of a luxury audio amplifier. 

- **Density:** 4/10 ("Living Room Balanced") — Generous spatial breathing room, allowing active media backdrops to dominate the upper 60% of the screen while interactive components rest in a grounded lower shelf.
- **Variance:** 6/10 ("Offset Dynamic Shelf") — Asymmetric card sizing that distinguishes featured primary media from utility tools.
- **Motion:** 8/10 ("Physical Spring Physics") — Zero linear easing. Tiles physically scale and illuminate with weighted momentum upon D-Pad focus.

---

## 2. Color Palette & Functional Roles
Calibrated to minimize eye strain in pitch-black rooms and prevent OLED image retention while maintaining crisp, high-contrast readability.

- **Deep Obsidian** (`#0B0C0E`) — Deepest canvas floor; pitch-dark living room base.
- **Elevated Slate** (`#14161B`) — Surface base for containers, menus, and side navigation rails.
- **Frosted Mica** (`rgba(255, 255, 255, 0.06)`) — Default inactive tile background with 20px hardware backdrop-blur.
- **Focus Beacon** (`#FFFFFF`) — High-contrast 2px border applied exclusively to the actively focused tile.
- **Polar Text** (`#F2F2F5`) — Primary headline typography, movie titles, and category headers.
- **Subdued Mist** (`#8A8D98`) — Secondary metadata: durations, release years, audio codecs (e.g., "1080p · 5.1").
- **Amber Horizon** (`#E5A93C`) — Singular functional accent (68% saturation) reserved for live broadcast indicators, active playback progress, and selected tabs.

*Strict Rules: Absolute black (`#000000`) is banned. Neon purples, blues, and outer-glow drop shadows are strictly forbidden.*

---

## 3. 10-Foot Typographic Architecture
At a 3-meter viewing distance, standard mobile/desktop typography becomes illegible. Type hierarchy is driven by optical weight, wide tracking, and generous leading.

- **Primary Display (Movie Titles / Section Headers):** `Cabinet Grotesk` or `Outfit` (Bold / Extrabold, 32px to 48px, tracking -0.02em). Confident, wide architecture that never wraps past 2 lines.
- **Body & Subtitles:** `Satoshi` (Medium, 18px to 22px, leading relaxed at 1.4).
- **Technical Badges & Timecodes:** `JetBrains Mono` (SemiBold, 13px to 15px, uppercase, tracking +0.06em) for technical tags like `HEVC`, `1080P`, `2:14:00`.
- **Banned:** `Inter`, `Roboto`, Arial, and all generic serif fonts (`Times`, `Georgia`).

---

## 4. Component Stylings & Interaction Mechanics

### 1. The Interactive App Tile (Focus Card)
* **Default State:** Flat rectangular card, rounded corners (`1.25rem` / `20px`), background in Frosted Mica (`rgba(255, 255, 255, 0.06)`), 1px subtle boundary border (`rgba(255, 255, 255, 0.08)`).
* **Focused State (Remote D-Pad Highlight):**
  * Hardware transform: `transform: scale(1.08) translateY(-4px)`.
  * Border illuminates to solid Polar Beacon White (`2px solid #FFFFFF`).
  * Ambient depth: Diffused, non-colored drop shadow (`0 16px 32px rgba(0, 0, 0, 0.6)`).
  * Subtitle text below the card smoothly fades in from `opacity: 0` to `opacity: 1`.
* **Pressed State (`DPAD_CENTER` / Enter):**
  * Instant tactile pushback: `transform: scale(1.03)`.

### 2. The Signature "Eden" Bottom Shelf (Samsung Tizen Inspired)
* Content is anchored along the bottom 35% of the viewport.
* Scrolling horizontally shifts the row smoothly while keeping the currently focused item centered at the 25% screen coordinate.
* As focus shifts from tile to tile, the background artwork in the top 65% cross-fades over 280ms (`transition: opacity 280ms cubic-bezier(0.16, 1, 0.3, 1)`).

### 3. Media Metadata Pill Badge
* Compact pill with `0.5rem` / `8px` padding, filled with `rgba(255, 255, 255, 0.1)`.
* Displays codec specifications cleanly: `[1080P]`, `[DOLBY 5.1]`, `[HDR10]`.

---

## 5. Layout & Spatial Principles
* **Aspect Ratio:** Fixed 16:9 widescreen canvas (`1920x1080` reference resolution).
* **Safe Action Zone:** Mandatory 5% internal margin padding on all edges (overscan protection for older television panels). No interactive element sits closer than 60px from the screen edge.
* **No Cluttered Grids:** A single active horizontal carousel at any time. Vertical D-Pad movements switch between shelves (e.g., "Favorites", "Installed Apps", "System Tools").
* **No Dead Space:** The top 60% of the screen is an active canvas showcasing high-resolution art, title logos, and synopsis of the item currently highlighted by the user's remote.

---

## 6. Motion Physics (Emil Kowalski Standard)
* **Spring Dynamics:** Remote navigation transitions use physical spring physics (`stiffness: 140, damping: 18`). Motion feels weighted and tactile, like rolling a mechanical bearing.
* **Composited GPU Performance:**
  * Animate **ONLY** `transform` and `opacity`.
  * Never animate layout dimensions (`width`, `height`, `margin`, `top`, `left`).
  * 60fps fluidity is mandatory on low-power ARM SoCs (MediaTek MT8695).
* **Instant Input Response:** Zero transition delay on D-pad input. The visual frame begins rendering within 16ms of remote keypress.

---

## 7. Anti-Patterns & Banned AI Tells
* ❌ **NO Emojis anywhere** in the interface.
* ❌ **NO Purple or Neon Gradients** or floating SaaS gradient blobs.
* ❌ **NO Overlapping Text** on top of busy background photography without a dedicated gradient veil.
* ❌ **NO Generic AI Copywriting:** Words like "Elevate your entertainment", "Unleash the power", "Seamless experience" are strictly banned. Use direct functional labels: "Continue Watching", "Installed Apps", "Storage".
* ❌ **NO Tiny Mouse-Pointer Targets:** Every interactive zone must be selectable with a 4-way D-Pad.
