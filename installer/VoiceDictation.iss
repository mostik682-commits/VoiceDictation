; Інсталятор VoiceDictation (Inno Setup 6). Збирається скриптом build_installer.py.
; Ставить програму лише для поточного користувача — права адміністратора не потрібні.

#define AppName "VoiceDictation"
#define AppVersion "1.2.0"
#define AppExe "VoiceDictation.exe"

[Setup]
AppId={{6B0C4A52-3D7E-4F4B-9E64-2F1C9B7D5A10}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher=VoiceDictation
PrivilegesRequired=lowest
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
DisableDirPage=yes
OutputDir=Output
OutputBaseFilename=VoiceDictation-Setup
SetupIconFile=VoiceDictation.ico
UninstallDisplayIcon={app}\{#AppExe}
UninstallDisplayName={#AppName}
WizardStyle=modern
Compression=lzma2/max
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
; майстер вибирає мову за мовою Windows; якщо її немає в списку — англійську
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "uk"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[CustomMessages]
en.TaskDesktop=Create a desktop shortcut
en.TaskAutostart=Start with Windows
en.IconHowTo=How to use
en.IconUninstall=Uninstall {#AppName}
en.RunApp=Launch {#AppName}
uk.TaskDesktop=Створити ярлик на робочому столі
uk.TaskAutostart=Запускати разом з Windows
uk.IconHowTo=Як користуватися
uk.IconUninstall=Видалити {#AppName}
uk.RunApp=Запустити {#AppName}

[Tasks]
Name: "desktopicon"; Description: "{cm:TaskDesktop}"
Name: "autostart"; Description: "{cm:TaskAutostart}"

[Files]
Source: "dist\VoiceDictation\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "Як користуватися.txt"; DestDir: "{app}"; Flags: ignoreversion; Languages: uk
Source: "HowToUse.txt"; DestDir: "{app}"; Flags: ignoreversion; Languages: en

[Icons]
Name: "{autoprograms}\{#AppName}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{autoprograms}\{#AppName}\{cm:IconHowTo}"; Filename: "{app}\Як користуватися.txt"; Languages: uk
Name: "{autoprograms}\{#AppName}\{cm:IconHowTo}"; Filename: "{app}\HowToUse.txt"; Languages: en
Name: "{autoprograms}\{#AppName}\{cm:IconUninstall}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Registry]
; той самий запис, що вмикає/вимикає пункт «Запускати разом з Windows» у меню трею
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "{#AppName}"; ValueData: """{app}\{#AppExe}"""; Flags: uninsdeletevalue; Tasks: autostart

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:RunApp}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{sys}\taskkill.exe"; Parameters: "/f /im {#AppExe}"; Flags: runhidden; RunOnceId: "StopApp"

[UninstallDelete]
; налаштування, ключ OpenAI, журнал і останній запис
Type: filesandordirs; Name: "{userappdata}\{#AppName}"
; запис автозапуску міг з'явитися з меню трею, а не з інсталятора
Type: files; Name: "{app}\*.log"

[Code]
function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  Code: Integer;
begin
  // оновлення поверх запущеної програми: спершу закриваємо її
  Exec(ExpandConstant('{sys}\taskkill.exe'), '/f /im {#AppExe}', '', SW_HIDE, ewWaitUntilTerminated, Code);
  Result := '';
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  // автозапуск, увімкнений з меню трею, теж прибираємо
  if CurUninstallStep = usPostUninstall then
    RegDeleteValue(HKCU, 'Software\Microsoft\Windows\CurrentVersion\Run', '{#AppName}');
end;
