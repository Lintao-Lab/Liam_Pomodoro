' Liam Pomodoro launcher (Windows) - invisible wrapper so no console window flashes.
' Double-click this file, or run: wscript windows.vbs
Dim Shell, Fso, ScriptDir
Set Fso = CreateObject("Scripting.FileSystemObject")
ScriptDir = Fso.GetParentFolderName(WScript.ScriptFullName)
Set Shell = CreateObject("WScript.Shell")
Shell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -File """ & ScriptDir & "\windows.ps1""", 0, False
