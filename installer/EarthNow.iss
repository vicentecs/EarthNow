; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define EarthNowName "Earth Now"
#define EarthNowVersion "1.0.3"
#define EarthNowPublisher "VicenteCS"
#define EarthNowURL "https://github.com/vicentecs/EarthNow"
#define EarthNowExeName "EarthNow.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{359BAC38-A46D-4ED5-9836-074B748E3E21}
AppName={#EarthNowName}
AppVersion={#EarthNowVersion}
;AppVerName={#EarthNowName} {#EarthNowVersion}
AppPublisher={#EarthNowPublisher}
AppPublisherURL={#EarthNowURL}
AppSupportURL={#EarthNowURL}
AppUpdatesURL={#EarthNowURL}
DefaultDirName={pf}\EarthNow
DefaultGroupName={#EarthNowName}
AllowNoIcons=yes
OutputBaseFilename=Setup-EarthNow
Compression=lzma
SolidCompression=yes

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "EarthNow.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "libeay32.dll"; DestDir: "{app}"
Source: "ssleay32.dll"; DestDir: "{app}"

[Icons]
Name: "{group}\{#EarthNowName}"; Filename: "{app}\{#EarthNowExeName}"
Name: "{group}\{cm:UninstallProgram,{#EarthNowName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#EarthNowName}"; Filename: "{app}\{#EarthNowExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#EarthNowName}"; Filename: "{app}\{#EarthNowExeName}"; Tasks: quicklaunchicon
Name: "{userstartup}\{#EarthNowName}"; Filename: "{app}\{#EarthNowExeName}"; Parameters: "-startup"

[Run]
Filename: "{app}\{#EarthNowExeName}"; Description: "{cm:LaunchProgram,{#StringChange(EarthNowName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
