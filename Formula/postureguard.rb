class Postureguard < Formula
  desc "Real-time macOS posture monitor that lives in the menu bar"
  homepage "https://github.com/elliotverstraelen/posture-guard"
  url "https://github.com/elliotverstraelen/posture-guard/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "f522448a3395443dd92d959358f44d52542cc29f3f35befb59bc3542d605175b" # postureguard
  license "MIT"

  # macOS only — uses osascript, rumps (AppKit), AVFoundation camera
  depends_on :macos
  depends_on "python@3.9"

  # ── Python dependencies ──────────────────────────────────────────────────────
  # These match requirements-menubar.txt — no Flask, no torch, no HuggingFace.

  resource "mediapipe" do
    url "https://files.pythonhosted.org/packages/source/m/mediapipe/mediapipe-0.10.14.tar.gz"
    sha256 "d4bb54eb07f62e97d8f3ed7ddbb6ae9e3d7bf13d3be2f1dd50acdaaa5e25f47b"
  end

  resource "opencv-python" do
    url "https://files.pythonhosted.org/packages/source/o/opencv-python/opencv-python-4.10.0.84.tar.gz"
    sha256 "a75c45f25e9c7e5fcbfe87dbeef3ffe71ccd10a8e36f1e3e7dc8de4ffe7a6cf5"
  end

  resource "rumps" do
    url "https://files.pythonhosted.org/packages/source/r/rumps/rumps-0.4.0.tar.gz"
    sha256 "4da6af2d0f3b29ae7e4ea5f1b1a5d6ea2b9b3a7c7fd66e7b04e39d1e49b00ca7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/source/r/requests/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9f9646d4ba373703a468bbd090d5cd6f4ef746d42a"
  end

  # ── Install ──────────────────────────────────────────────────────────────────

  def install
    # Create isolated virtualenv with Python 3.9
    venv = virtualenv_create(libexec, "python3.9")

    # Install pip resources (declared above)
    venv.pip_install resources

    # Install the app source into the venv
    venv.pip_install buildpath

    # Create the  postureguard  launcher in the Homebrew bin
    (bin/"postureguard").write <<~SH
      #!/bin/bash
      exec "#{libexec}/bin/postureguard" "$@"
    SH
    chmod 0755, bin/"postureguard"
  end

  # ── Post-install notes ───────────────────────────────────────────────────────

  def caveats
    <<~EOS
      PostureGuard is a menu bar app — no window will open.
      Look for the 🧍 icon in your menu bar after launching.

      ═══ Camera access ════════════════════════════════════
      macOS will ask for camera permission on the first run.
      If the prompt does not appear, go to:
        System Settings → Privacy & Security → Camera
      and enable PostureGuard.

      ═══ AI coaching tips (optional) ══════════════════════
      Install Ollama for personalised tips:
        brew install ollama
        ollama serve
        ollama pull qwen3:8b

      Without Ollama the app works fine using built-in tips.

      ═══ Launch ═══════════════════════════════════════════
        postureguard
      Or add it to Login Items in System Settings so it
      starts automatically.
    EOS
  end

  test do
    # Verify the script is importable without a display / camera
    system bin/"postureguard", "--help"
  end
end
