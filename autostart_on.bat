@echo off
cd /d "%~dp0"
powershell -NoProfile -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Startup')+'\VoiceDictation.lnk'); $s.TargetPath='%~dp0.venv\Scripts\pythonw.exe'; $s.Arguments='\"%~dp0dictation.py\"'; $s.WorkingDirectory='%~dp0'; $s.Save()"
echo Autostart enabled.
pause
