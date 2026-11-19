# VoiceDictation

**Voice dictation for any Windows app.** Hold a key, speak, release — the text appears wherever your cursor is: Word, browser, Telegram, email, anything.

🇺🇦 [Українською](README.uk.md)

![Windows 10/11](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D4?logo=windows&logoColor=white)
![License: MIT](https://img.shields.io/badge/license-MIT-green)
[![Latest release](https://img.shields.io/github/v/release/mostik682-commits/VoiceDictation)](https://github.com/mostik682-commits/VoiceDictation/releases/latest)

## Features

- **Hold-to-talk anywhere.** Hold **Right Ctrl**, speak, release. Punctuation, capital letters, abbreviations and recognition mistakes are fixed automatically, then the text is pasted at the cursor. Your clipboard is restored afterwards.
- **18 recognition languages.** *Auto* (the service detects the language of each phrase), Ukrainian, Russian, English, Polish, German, French, Spanish, Italian, Portuguese, Czech, Slovak, Romanian, Bulgarian, Turkish, Arabic, Japanese, Chinese. Switch from the tray icon in one click.
- **Rewrite menu for selected text** (`Ctrl + Space`): *cut the fluff*, *formal business style*, *friendly style with emoji*, or **your own voice command** — "translate to English", "make it shorter", "turn it into a list"… `Ctrl + Z` undoes the change.
- **Personal dictionary** for names, surnames and abbreviations that must be written exactly your way.
- **Free to run.** Bring your own key: [Groq](https://console.groq.com/keys) is free (daily limits), [OpenAI](https://platform.openai.com/api-keys) is paid (≈ $0.36 per hour of dictation) and the most accurate.
- **No admin rights, no account, no telemetry.** Audio goes only to the service you picked, with your own key. Settings and key stay on your PC in `%APPDATA%\VoiceDictation`.

> The app interface is currently in Ukrainian. Dictation itself works in any of the languages above.

## Install

1. Download **`VoiceDictation-Setup.exe`** from the [latest release](https://github.com/mostik682-commits/VoiceDictation/releases/latest) and run it (Next → Install → Finish).
2. Windows may show a blue *"Windows protected your PC"* window — the installer is not code-signed. Click **More info → Run anyway**.
   If Smart App Control is **On**, Windows can block unsigned apps; see [Smart App Control](#smart-app-control).
3. On first launch the app asks which service to use. Pick **Groq** (free), create a key at <https://console.groq.com/keys>, press **Paste** → **Save**.
4. Open Notepad, hold **Right Ctrl**, say something, release.

No Right Ctrl on your keyboard? Click the tray microphone icon → *Settings* → *Hotkeys*.

### Install with an AI agent

Using Claude Code, Codex, or another coding agent? Open this repository (or just paste its URL) and say **"Help me install VoiceDictation"**. The agent follows [`AGENTS.md`](AGENTS.md) / [`CLAUDE.md`](CLAUDE.md) and walks you through it step by step without ever asking you to paste your API key into the chat.

## Usage

| Action | How |
| --- | --- |
| Dictate | Hold **Right Ctrl**, speak, release |
| Rewrite selected text | Select text → `Ctrl + Space` → pick an item (click, arrows + Enter, or 1–4) |
| Custom rewrite by voice | `Ctrl + Space` → item 4 → say what to do, e.g. *"Translate to English"* |
| Undo a rewrite | `Ctrl + Z` |
| Change language | Tray icon → **Language** |
| Settings | Click the tray icon → hotkeys, services & keys, language, dictionary |

The full (Ukrainian) manual is in [`installer/Як користуватися.txt`](installer/%D0%AF%D0%BA%20%D0%BA%D0%BE%D1%80%D0%B8%D1%81%D1%82%D1%83%D0%B2%D0%B0%D1%82%D0%B8%D1%81%D1%8F.txt).

### Settings file

`%APPDATA%\VoiceDictation\config.json` (changes are picked up within a few seconds):

| Key | Meaning |
| --- | --- |
| `language` | `""` = auto-detect, or a code: `uk`, `ru`, `en`, `pl`, `de`, … |
| `provider` / `text_provider` | `openai` or `groq` for recognition / rewriting |
| `dictionary` | list of terms to spell exactly |
| `cleanup_prompt` | rules for the automatic clean-up after dictation |
| `command_menu` | items of the `Ctrl + Space` menu (`title`, `prompt`, `done`) |

## Language: Auto or fixed?

*Auto* is the most convenient if you dictate in several languages. If you always dictate in one language, pick it explicitly — short phrases (one or two words) and noisy recordings are recognised more reliably that way. With *Auto*, mixed-language sentences are transcribed as one language, so foreign words may be written in the wrong script.

## Smart App Control

Windows 11 *Smart App Control* can block any unsigned installer. Check it in **Windows Security → App & browser control → Smart App Control settings**. *Off* and *Evaluation* are fine. If it is *On*, you can run the app [from source](#run-from-source) instead. (Turning Smart App Control off is permanent until Windows is reinstalled — that is your decision, not something this project asks you to do.)

## Run from source

Requires Python 3.10+ on Windows.

```powershell
py -3 -m venv .venv
.venv\Scripts\python -m pip install -r requirements.txt
.venv\Scripts\python dictation.py
```

(`install.bat`, `start.bat`, `debug.bat`, `autostart_on.bat` and `autostart_off.bat` do the same for double-click use.)

## Build the installer

Requires Python 3.10+ and [Inno Setup 6](https://jrsoftware.org/isinfo.php).

```powershell
py -3 -m venv .buildvenv
.buildvenv\Scripts\python -m pip install -r requirements.txt pyinstaller
.buildvenv\Scripts\python installer\build_installer.py
# result: installer\Output\VoiceDictation-Setup.exe
```

## Troubleshooting

- **Nothing is pasted / silence:** Windows *Settings → System → Sound →* your microphone, input volume ≈ 75 %. Also *Privacy & security → Microphone →* allow desktop apps.
- **"Key not accepted":** the key was copied incompletely. Create a new one and paste it in *Settings → Services*.
- **"Rate limit reached":** Groq has per-minute and per-day limits. Wait, or use a paid OpenAI key.
- **No tray icon:** it may be hidden under the **^** arrow near the clock.
- **Log:** `%APPDATA%\VoiceDictation\dictation.log` (contains no keys).

## Uninstall

Start menu → VoiceDictation → *Uninstall VoiceDictation* (also removes the settings and the saved key).

## License

[MIT](LICENSE)
