; -- Example1.iss --
; Demonstrates copying 3 files and creating an icon.

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
AppName=Erudit
AppVersion=1.0.0
WizardStyle=modern
DefaultDirName={autopf}\Erudit
DefaultGroupName=Erudit
UninstallDisplayIcon={app}\Erudit_Console.exe
Compression=lzma2
SolidCompression=yes
OutputDir=Installer

[Files]
Source: "Erudit_Console.exe"; DestDir: "{app}"
Source: "Erudit_Console.ico"; DestDir: "{app}"
Source: "rule.txt"; DestDir: "{app}"
Source: "words.txt"; DestDir: "{app}"




[Icons]
Name: "{group}\Erudit"; Filename: "{app}\Erudit.exe"
