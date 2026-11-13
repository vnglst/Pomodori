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

Install the latest published release with Homebrew:

```bash
brew install --cask vnglst/tap/pomodori
```

Requires macOS 12 Monterey or later. Requires an Apple Silicon Mac.

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

## Publishing releases manually

Use an Apple Silicon Mac with Xcode Command Line Tools, Homebrew, and an
authenticated GitHub CLI (`gh auth login`). Run these commands from this
repository on `main`, after committing the app changes you want to release.
Choose an unused version; `1.0.1` below is an example.

Disable the tag workflow so it does not rebuild or replace the archive you
publish manually. This setting persists until you re-enable it:

```bash
gh workflow disable release.yml --repo vnglst/Pomodori
git pull --ff-only
VERSION=1.0.1
ARCHIVE="$(mktemp -d)/Pomodori-$VERSION.zip"
```

Build the app, verify its ad-hoc signature, and create the release ZIP:

```bash
VERSION="$VERSION" ./build.sh
codesign --verify --deep --strict build/Pomodori.app
ditto -c -k --sequesterRsrc --keepParent build/Pomodori.app "$ARCHIVE"
shasum -a 256 "$ARCHIVE"
```

In `Casks/pomodori.rb`, set `version` to `$VERSION` and `sha256` to the
checksum printed above. Commit the cask, tag that commit, and publish the ZIP:

```bash
git add Casks/pomodori.rb
git commit -m "chore(release): Pomodori $VERSION"
git tag "v$VERSION"
git push origin main "v$VERSION"
gh release create "v$VERSION" "$ARCHIVE" \
  --repo vnglst/Pomodori --verify-tag --title "Pomodori $VERSION" --generate-notes
```

Update the shared tap using your local GitHub credentials. If you do not
already have a sibling checkout, clone it once with
`git clone https://github.com/vnglst/homebrew-tap.git ../homebrew-tap`.
Then, from this app repository:

```bash
git -C ../homebrew-tap pull --ff-only
cp Casks/pomodori.rb ../homebrew-tap/Casks/pomodori.rb
git -C ../homebrew-tap add Casks/pomodori.rb
git -C ../homebrew-tap commit -m "chore(release): Pomodori $VERSION"
git -C ../homebrew-tap push
```

Check the published download and checksum through Homebrew:

```bash
brew update
brew fetch --cask --force vnglst/tap/pomodori
brew info --cask vnglst/tap/pomodori
```

Users can then install or upgrade with `brew install --cask vnglst/tap/pomodori`
or `brew upgrade --cask pomodori`. No `HOMEBREW_TAP_TOKEN` secret is needed for
this manual process.

To switch back to automatic releases later, configure `HOMEBREW_TAP_TOKEN`
with Contents write access limited to `vnglst/homebrew-tap`, harden the token
handling in `.github/workflows/release.yml`, and run
`gh workflow enable release.yml --repo vnglst/Pomodori`.
