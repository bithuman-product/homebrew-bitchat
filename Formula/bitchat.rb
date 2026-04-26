# Homebrew formula for `bitchat` — on-device voice chat CLI for macOS, by bitHuman.
# https://www.bithuman.ai
#
# Install:
#   brew tap bithuman-product/bitchat
#   brew install bitchat
#   bitchat
#
# (Tap nickname `bithuman-product/bitchat` resolves to the
# `homebrew-bitchat` repo via Homebrew's convention — the leading
# `homebrew-` prefix is auto-prepended to the repo name.)
#
# This formula installs a prebuilt, Developer ID-signed and Apple-
# notarised binary. No Xcode required on the user's machine. First
# launch downloads ~3 GB of model weights to ~/.cache/huggingface/hub/.
class Bitchat < Formula
  desc "On-device voice chat CLI for macOS (ASR + LLM + TTS, all local)"
  homepage "https://github.com/bithuman-product/homebrew-bitchat"
  version "0.2.1"
  url "https://github.com/bithuman-product/homebrew-bitchat/releases/download/v#{version}/bitchat-#{version}.zip"
  sha256 "3d0f4f10fe176696eac16e91c602f1d257dc28b8cecb3d9c5937e0f98bc2b52e"
  license "Apache-2.0"

  depends_on macos: :sequoia
  depends_on arch: :arm64

  def install
    # The release zip layout is flat: the binary plus its sibling
    # resource bundles all live at the top level. MLX's bundle lookup
    # is RELATIVE to the binary, so we install everything into libexec
    # and put a tiny exec-wrapper in bin so the binary's runtime
    # neighbours are still next to it after Homebrew links.
    libexec.install Dir["bitchat", "*.bundle"]
    (bin/"bitchat").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bitchat" "$@"
    EOS
    (bin/"bitchat").chmod 0755
  end

  test do
    # --help exits 0 with non-trivial output. Mic permissions can't
    # be granted from `brew test`, so a real boot is out of scope.
    assert_match "bitchat", shell_output("#{bin}/bitchat --help")
  end
end
