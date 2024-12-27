; -- Example1.iss --
; Demonstrates copying 3 files and creating an icon.

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
AppName=Erudit
AppVersion=1.0.0
WizardStyle=modern
DefaultDirName={autopf}\Erudit
DefaultGroupName=Erudit
UninstallDisplayIcon={app}\Erudit.exe
Compression=lzma2
SolidCompression=yes
OutputDir=Installer

[Files]
Source: "Erudit.exe"; DestDir: "{app}"
Source: "Erudit.ico"; DestDir: "{app}"
Source: "audio.wav"; DestDir: "{app}"
Source: "btn.wav"; DestDir: "{app}"
Source: "rule.txt"; DestDir: "{app}"
Source: "words.txt"; DestDir: "{app}"
Source: "Unit2.dcu"; DestDir: "{app}"
Source: "Unit1.dcu"; DestDir: "{app}"



[Icons]
Name: "{group}\Erudit"; Filename: "{app}\Erudit.exe"
