# Instructions for an AI agent: help the user install VoiceDictation

The person who sent you here wants to install **VoiceDictation** on their Windows PC.
They are most likely not a programmer. Write in the language they use (default: Ukrainian),
in plain words, **one step at a time**, and wait for their reply after each step.

## What this is

VoiceDictation: dictation into any Windows window. The user holds **Right Ctrl**, speaks, releases,
and the text is pasted at the cursor. `Ctrl + Space` on selected text opens a rewrite menu
(cut the fluff, business style, friendly style, or a custom voice command). Recognition and rewriting
are done by online services — Groq (free, with limits) or OpenAI (paid) — using the user's own key.
The recognition language is *Auto* by default and can be changed in Settings → Language
or from the tray icon → Language. The interface is English or Ukrainian (follows Windows; changeable in
Settings → Language → *Interface language*).

Repository layout: `dictation.py` (the app), `installer/` (PyInstaller + Inno Setup scripts),
`requirements.txt`. Releases contain a ready installer `VoiceDictation-Setup.exe`
(x64, no admin rights, installs to `%LOCALAPPDATA%\Programs\VoiceDictation`).

## Steps

1. **Check the system.** Windows 10/11, 64-bit. Smart App Control state can be read (change nothing):
   `Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy' -Name VerifiedAndReputablePolicyState`
   - `0` = off, `2` = evaluation: fine.
   - `1` = on: the unsigned installer will most likely be blocked. Explain it to the user and offer to
     run from source instead (see README → *Run from source*; needs Python 3.10+).
     **Never turn Smart App Control off yourself or change other security settings** — it cannot be
     turned back on without reinstalling Windows; that decision belongs to the user alone.

2. **Get the installer.** Open the latest release: `https://github.com/mostik682-commits/VoiceDictation/releases/latest`
   and have the user download `VoiceDictation-Setup.exe` (downloading a file needs the user's explicit OK:
   say the filename, the source and the size, ~35 MB).

3. **Install: ask the user to double-click `VoiceDictation-Setup.exe` in File Explorer.**
   Do not run the installer from your own shell. Some agent apps (for example the Claude desktop app for
   Windows) run inside an MSIX container, where everything you launch writes to a hidden virtual copy of
   `AppData` (`%LOCALAPPDATA%\Packages\<app>\LocalCache\...`): the program would "install" there while the
   Start-menu shortcuts and autostart point into the void. If you must launch it yourself, do it through
   Explorer: `explorer.exe "<full path to VoiceDictation-Setup.exe>"`. The same applies to `VoiceDictation.exe`.
   - A blue *"Windows protected your PC"* window is normal (no code-signing certificate):
     *More info → Run anyway*.
   - Next → Install → Finish; leave "Launch VoiceDictation" ticked.

4. **Groq key.** Walk the user through `https://console.groq.com/keys` → sign in (Google works) →
   *Create API Key* → any name → copy the key (`gsk_...`, shown only once).
   **Never ask the user to paste the key into the chat and never repeat it.** They paste it into the
   app's own window.

5. **First launch.** The app opens the *Services* window. Choose Groq for *voice recognition* and for
   *text rewriting*, press *Paste* in the *Groq key* field, then *Save*. The key is verified, and a
   microphone icon appears next to the clock (it may hide under the **^** arrow).

6. **Language (optional).** Tray icon → *Language* (or Settings → *Language*): *Auto*, Ukrainian, Russian,
   English and 14 more. Advise a fixed language if the user always dictates in one language.

7. **Test.** Notepad → hold Right Ctrl → say a phrase → release. No Right Ctrl on the keyboard
   (common on laptops)? Tray icon → *Settings* → *Hotkeys*.

## Diagnostics

If you run inside an MSIX container, read the **real** files via `\\localhost\c$\...`, not via
`%APPDATA%`/`%LOCALAPPDATA%` (take the user name from `$env:USERNAME`):
- app: `\\localhost\c$\Users\<USER>\AppData\Local\Programs\VoiceDictation\VoiceDictation.exe`
- settings: `\\localhost\c$\Users\<USER>\AppData\Roaming\VoiceDictation\config.json`
  — **contains the API keys** (`openai_api_key`, `groq_api_key`). Never print it whole; show other fields only
  or replace keys with `***`. Don't edit the keys in the file: the user changes them in *Settings → Services*.
- log: `...\AppData\Roaming\VoiceDictation\dictation.log` (no keys). Read the last ~50 lines and explain
  in plain words what happened.
- is it running: `Get-Process VoiceDictation`.

Common problems:
- Silence / empty text: Settings → System → Sound → microphone → input volume ≈ 75 %;
  Privacy & security → Microphone → allow desktop apps.
- "Service did not accept the key": key copied incompletely — create a new one and paste it in *Settings → Services*.
- "Rate limit reached": Groq per-minute/day limits — wait, or use a paid OpenAI key.
- No tray icon: look under the **^** arrow, or start it from the Start menu.
- `Ctrl + Space` says it sees no selected text: select the text with the mouse first.
- Text comes out in the wrong language: Settings → *Language* (pick the language explicitly instead of *Auto*).

Uninstall: Start → VoiceDictation → *Uninstall VoiceDictation* (also removes the settings and the key).
