# Pomodori

A minimal macOS menu bar Pomodoro timer that helps you stay focused.

## The Philosophy

This project demonstrates how **personal software** can be created in the age of AI. Instead of downloading yet another app from the internet, you describe what you need, and it's built for you—tailored to your exact requirements.

- No bloat
- No subscription
- No tracking
- Just the functionality you asked for

## What It Does

- Lives in your menu bar (no dock icon)
- Beautiful red tomato icon in your menu bar
- 25-minute focus sessions (configurable: 25, 35, 45, or 60 minutes)
- 5-minute break automatically after each focus session
- Shows countdown timer when running
- Plays a gentle sound when timer completes
- Popup notification with automatic restart
- Right-click menu to adjust focus duration

## Build & Run

```bash
# Build
./build.sh

# Run
open build/Pomodori.app

# Or install to Applications
cp -r build/Pomodori.app /Applications/
```

## How It Was Made

This entire app was created through conversation. The user described what they wanted, and the AI assistant (powered by Kimi K2.5 via opencode) wrote the code, debugged it, and refined it based on feedback.

**Key technologies used:**
- Swift
- Cocoa framework
- Timer APIs
- System sounds

**Features added iteratively:**
- Real tomato emoji icon (from Twitter Twemoji)
- Colored menu bar icon support
- Configurable focus durations
- Sound notifications
- Clean popup alerts

## Why This Matters

In an era of bloated software, app stores, and endless subscriptions, this represents a return to **personal computing**. Software created exactly to your specifications, owned by you, modifiable by you.

## License

This is personal software. Use it, modify it, make it yours.
