# AGENTS.md

If the user asks you to install or set up VoiceDictation, follow the step-by-step guide in
[`CLAUDE.md`](CLAUDE.md) (it applies to any AI agent, not only Claude): one step at a time, never ask for
or repeat the user's API key, and have the user launch the installer from File Explorer.

If the user asks you to change the code: the whole app is `dictation.py`; the installer is built by
`installer/build_installer.py` (run it with the `.buildvenv` Python, see README → *Build the installer*).
