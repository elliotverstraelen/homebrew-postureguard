# homebrew-postureguard

Homebrew tap for [PostureGuard](https://github.com/elliotverstraelen/posture-guard) — a real-time macOS posture monitor that lives in the menu bar.

## Install

```bash
brew tap elliotverstraelen/postureguard
brew install postureguard
postureguard
```

## What gets installed

Only the native menu bar app (`rumps` + `mediapipe` + `opencv-python`).  
The Flask web dashboard and HuggingFace session reports are **not** installed by default — they are available for development by cloning the main repo and running `pip install -r requirements.txt`.
