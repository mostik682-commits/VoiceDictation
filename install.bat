@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo === VoiceDictation: installing ===
where py >nul 2>nul && (py -3 -m venv .venv) || (python -m venv .venv)
if not exist ".venv\Scripts\python.exe" (
  echo Python not found. Install Python 3.10+ from python.org and run again.
  pause
  exit /b 1
)
".venv\Scripts\python.exe" -m pip install --upgrade pip
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 (
  echo Install failed. See messages above.
  pause
  exit /b 1
)
echo.
echo Done. Now put your OpenAI key into config.json and run start.bat
start notepad "%~dp0config.json"
pause
