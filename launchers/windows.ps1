# Liam Pomodoro launcher (Windows)
# Runs serve.py, which picks a free port on first run and remembers it,
# then opens the app in the default browser.
# Serving over http://127.0.0.1 (instead of file://) is what allows browser
# notification permission to be granted; file:// pages cannot receive it.
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Serve = Join-Path $ScriptDir 'serve.py'

function Find-Python {
    foreach ($Name in @('python', 'py')) {
        $Command = Get-Command $Name -ErrorAction SilentlyContinue
        if (-not $Command) { continue }
        # The Microsoft Store placeholder under WindowsApps is not a real install.
        if ($Command.Source -like '*\WindowsApps\*') { continue }
        return $Command
    }
    return $null
}

$Python = Find-Python
if (-not $Python) {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show(
        'Liam Pomodoro needs Python 3. Install it from https://www.python.org/downloads/ and run this launcher again.',
        'Liam Pomodoro') | Out-Null
    exit 1
}

$Leaf = [System.IO.Path]::GetFileNameWithoutExtension($Python.Source)
$WindowlessName = if ($Leaf -eq 'py') { 'pyw.exe' } else { 'pythonw.exe' }
$Exe = Join-Path (Split-Path -Parent $Python.Source) $WindowlessName
if (-not (Test-Path $Exe)) { $Exe = $Python.Source }

$PythonArgs = @($Serve)
if ($Leaf -eq 'py') { $PythonArgs = @('-3') + $PythonArgs }

Start-Process -FilePath $Exe -ArgumentList $PythonArgs -WindowStyle Hidden
