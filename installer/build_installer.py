"""
Збирає інсталятор VoiceDictation-Setup.exe.

Запуск (з папки програми):
    .venv\\Scripts\\python.exe installer\\build_installer.py

Кроки: окреме середовище для збірки (.buildvenv) -> іконка -> PyInstaller (папка з VoiceDictation.exe)
-> Inno Setup (один файл-інсталятор у installer\\Output).
"""

import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
VENV = os.path.join(ROOT, ".buildvenv")
VPY = os.path.join(VENV, "Scripts", "python.exe")
ICON = os.path.join(HERE, "VoiceDictation.ico")
ISCC_CANDIDATES = [
    os.path.join(os.environ.get("LOCALAPPDATA", ""), "Programs", "Inno Setup 6", "ISCC.exe"),
    r"C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    r"C:\Program Files\Inno Setup 6\ISCC.exe",
]


def run(*cmd):
    print(">", " ".join(cmd), flush=True)
    subprocess.run(cmd, check=True)


def make_icon():
    """Та сама іконка мікрофона, що й у треї (червона), у кількох розмірах."""
    from PIL import Image, ImageDraw
    s = 4  # малюємо 256x256 (масштаб 4 від іконки 64x64 у треї)
    img = Image.new("RGBA", (64 * s, 64 * s), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse((4 * s, 4 * s, 60 * s, 60 * s), fill=(210, 40, 40))
    d.rounded_rectangle((25 * s, 14 * s, 39 * s, 38 * s), radius=7 * s, fill="white")
    d.arc((19 * s, 24 * s, 45 * s, 46 * s), start=0, end=180, fill="white", width=3 * s)
    d.line((32 * s, 46 * s, 32 * s, 52 * s), fill="white", width=3 * s)
    img.save(ICON, sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])


def main():
    if not os.path.exists(VPY):
        run(sys.executable, "-m", "venv", VENV)
    run(VPY, "-m", "pip", "install", "-q", "--disable-pip-version-check",
        "-r", os.path.join(ROOT, "requirements.txt"), "pyinstaller")
    make_icon()
    run(VPY, "-m", "PyInstaller", "--noconfirm", "--clean", "--windowed",
        "--name", "VoiceDictation",
        "--icon", ICON,
        "--hidden-import", "pystray._win32",
        "--distpath", os.path.join(HERE, "dist"),
        "--workpath", os.path.join(HERE, "build"),
        "--specpath", os.path.join(HERE, "build"),
        os.path.join(ROOT, "dictation.py"))
    iscc = next((p for p in ISCC_CANDIDATES if os.path.exists(p)), None)
    if not iscc:
        sys.exit("Не знайдено Inno Setup 6 (ISCC.exe) — встанови його, щоб зібрати інсталятор.")
    run(iscc, os.path.join(HERE, "VoiceDictation.iss"))
    print("\nГотово:", os.path.join(HERE, "Output", "VoiceDictation-Setup.exe"))


if __name__ == "__main__":
    main()
