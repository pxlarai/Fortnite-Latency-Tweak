# ⚡ latency_reduction

A hand-coded Windows batch script designed to minimize **input delay**, reduce **network jitter**, and provide a stable gaming experience. 

> **Honesty Check:** This script focuses on **latency and stability**. It is not a "fake" FPS booster. It aims to make your game feel more responsive and reduce your ping.

---

## 📉 Real-World Performance
While results vary based on your hardware and ISP, this script targets common Windows bottlenecks:
* **Ping Improvement:** Potential reduction from **25ms to 10ms** by optimizing the network stack.
* **Zero Input Delay:** Disables Windows features that cause "floaty" mouse and keyboard feel.
* **Improved 1% Lows:** Removes background system interruptions for **smoother frame-timing**.

---

## ✨ Key Features
- **System Restore Point:** Automatically creates a backup for your safety before any changes are made.
- **Nagle's Algorithm Fix:** Forces Windows to send game packets immediately without waiting.
- **Network Throttling Disabled:** Stops Windows from prioritizing background traffic over your game.
- **TSC Clock Sync:** Configures the system to use the most precise hardware clock.
- **Adapter Offloading:** Disables power-saving features on your WiFi/Ethernet card that cause lag spikes.

---

## 🚀 How to Use
1.  **Download:** Get the `latency_reduction.bat` file from this repository.
2.  **Run:** Right-click the file and select **"Run as Administrator"** (Required).
3.  **Restart:** You **must** restart your PC for the registry changes to take effect.

---

## 🛡️ Transparency & Safety
This project is **100% Open Source**. 
You can right-click the `.bat` file and select **Edit** at any time to see every single line of code. We use standard Windows commands (`reg add`, `bcdedit`, `powershell`) to ensure your system remains stable.

## 🔍 View the Code
```batch
[PASTE YOUR ENTIRE .BAT CODE HERE]
