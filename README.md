# homebrew-bitchat — DEPRECATED

> ⚠️  This tap and the `bitchat` formula it ships have been **renamed**.
> The product is unchanged. Please migrate.

The CLI previously known as **`bitchat`** is now **`bithuman-cli`**, and
lives in the new tap [`bithuman-product/homebrew-bithuman`](https://github.com/bithuman-product/homebrew-bithuman).
The Swift SDK is now `bitHumanKit`. The product (on-device voice + video
chat for macOS 26 on Apple Silicon) is otherwise unchanged.

## Migrate

```sh
brew uninstall bitchat
brew untap bithuman-product/bitchat

brew tap bithuman-product/bithuman
brew install bithuman-cli
```

The new binary is invoked as `bithuman-cli` (e.g. `bithuman-cli video`).

## Why the rename

Brand consistency with bitHuman (the company) and with the wider product
family (`bitHumanKit` SDK, `bitHuman` desktop / iPad / iOS apps). The
old name remains here at v0.6.2 for reference, frozen — no further
releases land on this tap.

For ongoing updates, install commands, and docs:

→ https://github.com/bithuman-product/homebrew-bithuman

---

Made by [bitHuman](https://www.bithuman.ai). Apache-2.0.
