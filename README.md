<!--
SPDX-License-Identifier: Apache-2.0
title: bitchat — on-device voice chat for macOS
maintainer: bitHuman Inc.
homepage: https://www.bithuman.ai
project_type: cli, swift-library
platform: macOS 26+, Apple Silicon
runtime: 100% on-device (no network calls, no API keys)
keywords: voice-chat, on-device, local-llm, asr, tts, mlx, apple-silicon, gemma, qwen3-tts, kokoro-tts, voice-cloning, lip-sync, avatar, agents, swift, macos
-->

<p align="center">
  <a href="https://www.bithuman.ai">
    <img alt="bitHuman" src="https://www.bithuman.ai/og.png" width="220">
  </a>
</p>

<h1 align="center">bitchat</h1>

<p align="center">
  <strong>Talk to your Mac. 100% on-device.</strong><br>
  Voice chat with optional lip-synced avatar — ASR + LLM + TTS + face animation,<br>
  all running locally on Apple Silicon.<br>
  No network calls. No API keys. Built by <a href="https://www.bithuman.ai">bitHuman</a>.
</p>

<p align="center">
  <a href="#install"><img alt="brew install" src="https://img.shields.io/badge/brew-install%20bitchat-orange?style=flat-square"></a>
  <a href="#"><img alt="macOS 26+" src="https://img.shields.io/badge/macOS-26%2B-blue?style=flat-square"></a>
  <a href="#"><img alt="Apple Silicon" src="https://img.shields.io/badge/Apple%20Silicon-only-green?style=flat-square"></a>
  <a href="LICENSE"><img alt="Apache 2.0" src="https://img.shields.io/badge/license-Apache%202.0-lightgrey?style=flat-square"></a>
</p>

---

## What it does

`bitchat` turns your Mac into a real-time voice chatbot. You speak; it
transcribes, thinks, and replies out loud — and in **video mode** a small
floating face moves its lips in sync with the bot's voice. You can interrupt
mid-reply and it cuts off in ~50 ms. Everything runs locally:

```text
🎤  You speak
 ↓  Apple SpeechAnalyzer (built into macOS 26)
🧠  Gemma 4 E2B 4-bit on mlx-swift-lm    ← thinks
 ↓
🔊  Kokoro / Qwen3-TTS on mlx-audio-swift
 ↓  (video mode) bitHuman expression engine — DiT lip-sync at 25 FPS
🎧  You hear the reply (and optionally see it spoken)
```

No data leaves your machine. No cloud round-trip. Works offline once the
models are cached.

## Install

Requires **macOS 26 (Tahoe) or later** on **Apple Silicon** (M1+).

```sh
brew tap bithuman-product/bitchat
brew install bitchat
bitchat                  # voice (default)
bitchat video            # voice + animated face
```

That's it. First launch downloads the models (sizes below) to
`~/.cache/huggingface/hub/` and `~/Library/Application Support/bithuman/`.
Every launch after that is offline-only.

## Three modes

```sh
bitchat                                  # voice (default) — pure audio chat
bitchat text                             # text-only chat — pipe-friendly
bitchat video                            # voice + lip-synced animated avatar
bitchat video --image ~/me.jpg           # video chat with your portrait
```

| Mode | What you get | First-run download |
|---|---|---|
| `text` | LLM only. Pipe-friendly: `echo "hi" \| bitchat text`. | ~2 GB |
| `voice` (default) | ASR → LLM → TTS over the speakers. Voice cloning supported. | ~3 GB |
| `video` | Everything in voice + a floating circular window with a talking face. 8 bundled agents, drop-in face swap, voice gallery, prompt editor. | ~7 GB |

## ✨ Video mode — the main event

`bitchat video` opens a small floating circular window with a talking face.
Right-click the avatar to customize.

### Bundled agents

8 hand-curated personas, each with a face, voice, and personality wired
together. Pick one and the avatar's portrait, Kokoro voice, and system
prompt all swap at once. **Diego** is the default for fresh users.

| Agent | Vibe |
|---|---|
| **Diego** | laid-back roommate coach |
| **Nova** | energetic millennial storyteller |
| **Einstein** | warm physics mentor with simple analogies |
| **Riya** | confident-interview communication coach |
| **Lena** | bold stand-up comic for stage-presence drills |
| **Rae** | charismatic late-night talk-show host |
| **Dr. Maya** | seasoned ethics advisor |
| **Mason** | calm pricing strategist for creators |

### Customize anything

Right-click the avatar window to open a tidy SwiftUI menu:

- **Choose agent…** — 2-column gallery; click a card to apply.
- **Change image…** — pick a portrait from disk **or just drag-drop one**
  onto the avatar. The bitHuman expression engine VAE-encodes the new face
  in ~5 s and the avatar starts speaking through your portrait.
- **Change voice…** — gallery of 9 Kokoro voices grouped Feminine /
  Masculine. Click any card to audition it through the speakers; **Save**
  commits.
- **Change prompt…** — clean editor with 6 starter templates (Companion,
  Coach, Tutor, Storyteller, Coding buddy, Calm listener). Pills snap your
  prompt; you can still tweak before saving.

### Status at a glance

A colored ring around the avatar tells you what it's doing:

| Color | State |
|---|---|
| 🩵 cyan | listening |
| 🟣 violet | thinking (with a chasing arc) |
| 🟠 amber | speaking |

A label below the circle echoes the same. While the engine warms up at
launch, a brand-coral particle field pulses in the avatar's place.

### Quiet idle (no fans, no battery drain)

Continuous DiT inference for the avatar's idle breathing was holding the
GPU at ~90 %. v0.5.0 captures the first ~10 s of idle motion into a
per-portrait palindrome cache — once that buffer fills, bitchat plays the
frames forward → reverse → forward indefinitely instead of regenerating.
**GPU drops to near-zero during idle.** Speech still streams through DiT
live. The cache invalidates the moment you swap the portrait or pick a
different agent, then refills over the next ~10 s.

## Quick start

```sh
bitchat voice --voice Aiden              # English preset speaker
bitchat voice --voice ~/voices/me.wav    # clone your own voice (auto-transcribed)
bitchat voice --locale ja-JP             # listen + reply in Japanese
bitchat text --prompt "Be a deadpan ship's computer."
bitchat video --image ~/Desktop/me.jpg   # your face, default Kokoro voice
echo "summarise this:" | bitchat text    # use as a shell pipe
```

| flag | what it does |
|---|---|
| `--locale <bcp47>` | ASR + TTS language (default `en-US`). Examples: `en-US`, `ja-JP`, `zh-CN`, `es-ES`, `fr-FR`. |
| `--voice <preset\|path>` | (voice mode) Preset name **or** a path to a 10–20 s mono audio file. If a path, the voice is cloned and the transcript is auto-detected. |
| `--image <path>` | (video mode) Portrait file. Defaults to Diego's bundled portrait. |
| `--prompt <text\|@path>` | Override the system prompt. Inline string or `@/path/to/file.txt`. |
| `-h`, `--help` | Show usage. |

**Voice-mode preset speakers (Qwen3-TTS):** English: `Ryan`, `Aiden` ·
Chinese: `Vivian`, `Serena`, `Uncle_Fu`, `Dylan`, `Eric`.

**Video-mode voices (Kokoro):** `af_heart`, `af_alloy`, `af_aoede`, `af_kore`,
`bf_emma`, `am_adam`, `am_michael`, `am_echo`, `bm_george`. Pickable from
the right-click → "Change voice…" gallery.

**Controls:** Speak after `🎙️ Listening`. Start talking while the bot is
replying — it stops in ~50 ms (audio + avatar both). Cmd-Q or right-click →
"Quit bitchat" to exit.

## Models

| Stage | Model | Params | Quant | On-disk | Resident | License |
|---|---|---:|---|---:|---:|---|
| **ASR** | Apple SpeechAnalyzer | — | — | ~50 MB | ~50 MB | Apple, built-in |
| **LLM** | Gemma 4 E2B Instruct | 2 B | 4-bit | ~1.9 GB | ~2.5 GB | Apache 2.0 |
| **TTS — voice mode** | Qwen3-TTS-12Hz 0.6B | 0.6 B | 4-bit | ~1.0 GB | ~1.2 GB | Apache 2.0 |
| **TTS — video mode** | Kokoro 82M | 82 M | 4-bit | ~150 MB | ~200 MB | Apache 2.0 |
| **Avatar — video mode** | bitHuman expression engine (Wav2Vec2 + DiT + VAE) | — | float16 | ~3.7 GB | ~4 GB | bitHuman SDK |

Working set on a 24 GB M-series MacBook Pro:

- **text mode:** ~2.5 GB
- **voice mode:** ~4 GB
- **video mode:** ~8 GB

No swap pressure during normal conversation in any mode.

## Why bitchat?

- **Truly local.** Mic → ASR → LLM → TTS → avatar, all on-device. No API
  keys, no network egress, no per-token billing.
- **Real-time, with barge-in.** ~200–400 ms first-partial ASR, ~55–80 tok/s
  LLM, sentence-pipelined TTS, ~50 ms barge-in cutoff (audio + avatar both).
- **Voice cloning out of the box** (voice mode). Drop in a 10-second clip
  and bitchat uses it as the bot's voice — transcript is auto-detected via
  Apple's on-device speech recognition.
- **Drop-in face swap** (video mode). Drag any portrait onto the avatar
  and it becomes the new face after a ~5 s VAE encode. No retraining, no
  cloud upload.
- **Hardware AEC.** AVAudioEngine voice-processing IO unit means the bot
  doesn't transcribe its own voice back into the mic, even on laptop
  speakers — and in video mode the avatar's chunk-paired audio path keeps
  AEC's reference signal in lockstep with playback.
- **Quiet when idle.** A palindrome cache catches the avatar's idle motion
  after ~10 s; from then on, the GPU drops to near-zero until you speak.
  Leave bitchat open for hours without spinning the fans or draining the
  battery.
- **Apache 2.0** — both the code and the bundled model weights (the
  bitHuman expression-engine SDK ships under bitHuman's SDK license; see
  [LICENSE](LICENSE) for details).

## About bitHuman

bitchat is built and maintained by [**bitHuman**](https://www.bithuman.ai),
the team behind real-time on-device avatar engines. We make local-first
voice and avatar AI feel as good as the cloud services you're used to —
without sending your audio anywhere.

- 🌐 [www.bithuman.ai](https://www.bithuman.ai)
- 📦 More open-source: [github.com/bithuman-product](https://github.com/bithuman-product)
- 🪟 Halo (full desktop companion app): [github.com/bithuman-product/bithuman-halo-macos](https://github.com/bithuman-product/bithuman-halo-macos)

## Contributing / source

This repo (`bithuman-product/homebrew-bitchat`) hosts the **release
artefacts**: the Homebrew formula, notarised binaries, and this README. The
Swift source code lives in a separate dev repo and is currently
invitation-only — open an issue here if you'd like access.

For library embed (Swift Package Manager) instructions, build-from-source
notes, and architecture deep-dives, follow the link in any GitHub Release
description.

## Agents and LLMs

This repo publishes [`llms.txt`](llms.txt) — a structured manifest aimed at
AI coding assistants discovering and using bitchat. If you're an agent
trying to install or invoke bitchat on a user's machine, start there.

## License

Apache 2.0. See [`LICENSE`](LICENSE).

---

<p align="center">
  Made with ❤️ by <a href="https://www.bithuman.ai"><strong>bitHuman</strong></a>.<br>
  <sub>Local-first voice & avatar AI for the post-cloud era.</sub>
</p>
