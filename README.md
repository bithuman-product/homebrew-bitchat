<!--
SPDX-License-Identifier: Apache-2.0
title: bitchat — on-device voice chat for macOS
maintainer: bitHuman Inc.
homepage: https://www.bithuman.ai
project_type: cli, swift-library
platform: macOS 26+, Apple Silicon
runtime: 100% on-device (no network calls, no API keys)
keywords: voice-chat, on-device, local-llm, asr, tts, mlx, apple-silicon, gemma, qwen3-tts, voice-cloning, speech-to-text, text-to-speech, swift, macos
-->

<p align="center">
  <a href="https://www.bithuman.ai">
    <img alt="bitHuman" src="https://www.bithuman.ai/og.png" width="220">
  </a>
</p>

<h1 align="center">bitchat</h1>

<p align="center">
  <strong>Talk to your Mac. 100% on-device.</strong><br>
  ASR + LLM + TTS + voice cloning, all running locally on Apple Silicon.<br>
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

`bitchat` is a one-line command that turns your Mac into a real-time voice
chatbot. You speak; it transcribes, thinks, and replies out loud — with a
voice you can clone from a 10-second audio clip. You can interrupt mid-reply
and it cuts off in ~50 ms. Everything runs locally:

```text
🎤  You speak
 ↓  Apple SpeechAnalyzer (built into macOS 26)
🧠  Gemma 4 E2B 4-bit on mlx-swift-lm    ← thinks
 ↓
🔊  Qwen3-TTS 0.6B 4-bit on mlx-audio-swift, voice-cloned
 ↓
🎧  You hear the reply
```

No data leaves your machine. No cloud round-trip. Works offline once the
models are cached.

## Install

Requires **macOS 26 (Tahoe) or later** on **Apple Silicon** (M1+).

```sh
brew tap bithuman-product/bitchat
brew install bitchat
bitchat
```

That's it. First launch downloads ~3 GB of model weights to
`~/.cache/huggingface/hub/`. Every launch after that is offline-only.

## Three modes

```sh
bitchat                                  # voice (default)
bitchat text                             # text-only chat — pipe-friendly
bitchat video                            # voice + lip-synced animated avatar
bitchat video --image ~/me.jpg           # video chat with your portrait
```

## Quick start

```sh
bitchat voice --voice Aiden              # English preset speaker
bitchat voice --voice ~/voices/me.wav    # clone your own voice (auto-transcribed)
bitchat voice --locale ja-JP             # listen + reply in Japanese
bitchat text --prompt "Be a deadpan ship's computer."
echo "summarise this:" | bitchat text    # use as a shell pipe
```

`bitchat video` opens a small floating circular window with a
talking face. Speak to it, watch the mouth move with the bot's voice
in real time. First launch downloads the expression engine (~3.7 GB)
and a smaller TTS model (~150 MB) for the avatar pipeline.

| flag | what it does |
|---|---|
| `--locale <bcp47>` | ASR + TTS language (default `en-US`). Examples: `en-US`, `ja-JP`, `zh-CN`, `es-ES`, `fr-FR`. |
| `--voice <preset\|path>` | Preset name **or** a path to a 10–20 s mono audio file. If a path, the voice is cloned and the transcript is auto-detected. |
| `--prompt <text\|@path>` | Override the system prompt. Inline string or `@/path/to/file.txt`. |
| `-h`, `--help` | Show usage. |

**Preset speakers:** English: `Ryan`, `Aiden` · Chinese: `Vivian`, `Serena`,
`Uncle_Fu`, `Dylan`, `Eric`.

**Controls:** Speak after `🎙️  Listening`. Start talking while the bot is
replying — it stops in ~50 ms. Ctrl-C to quit.

## Models

| Stage | Model | Params | Quant | On-disk | Resident | License |
|---|---|---:|---|---:|---:|---|
| **ASR** | Apple SpeechAnalyzer | — | — | ~50 MB | ~50 MB | Apple, built-in |
| **LLM** | Gemma 4 E2B Instruct | 2 B | 4-bit | ~1.9 GB | ~2.5 GB | Apache 2.0 |
| **TTS** | Qwen3-TTS-12Hz 0.6B | 0.6 B | 4-bit | ~1.0 GB | ~1.2 GB | Apache 2.0 |

Working-set on a 24 GB M-series MacBook Pro: **~4 GB**. No swap pressure
during normal conversation.

## Why bitchat?

- **Truly local.** Mic → ASR → LLM → TTS, all on-device. No API keys, no
  network egress, no per-token billing.
- **Real-time, with barge-in.** ~200–400 ms first-partial ASR, ~55–80 tok/s
  LLM, sentence-pipelined TTS, ~50 ms barge-in cutoff.
- **Voice cloning out of the box.** Drop in a 10-second clip and bitchat
  uses it as the bot's voice — transcript is auto-detected via Apple's
  on-device speech recognition.
- **Hardware AEC.** AVAudioEngine voice-processing IO unit means the bot
  doesn't transcribe its own voice back into the mic, even on laptop
  speakers.
- **Apache 2.0** — both the code and the bundled model weights.

## About bitHuman

bitchat is built and maintained by [**bitHuman**](https://www.bithuman.ai),
the team behind real-time on-device avatar engines. We make local-first
voice and avatar AI feel as good as the cloud services you're used to —
without sending your audio anywhere.

- 🌐 [www.bithuman.ai](https://www.bithuman.ai)
- 📦 More open-source: [github.com/bithuman-product](https://github.com/bithuman-product)

## Contributing / source

This repo (`bithuman-product/homebrew-bitchat`) hosts the **release artefacts**: the
Homebrew formula, notarised binaries, and this README. The Swift source code
lives in a separate dev repo and is currently invitation-only — open an
issue here if you'd like access.

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
