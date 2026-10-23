# Liam Pomodoro launcher (Windows)
# Starts the tiny local server on 127.0.0.1:8788 if it is not already running,
# then opens the app in the default browser.
# Serving over http://127.0.0.1 (instead of file://) is what allows browser
# notification permission to be granted; file:// pages cannot receive it.
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Dir = Split-Path -Parent $ScriptDir
$Url = 'http://127.0.0.1:8788/'

function Test-PomodoroServer {
    try {
        $Client = New-Object System.Net.Sockets.TcpClient
        $Connected = $Client.ConnectAsync('127.0.0.1', 8788).Wait(500)
        $Client.Close()
        return $Connected
    } catch {
        return $false
    }
}

if (-not (Test-PomodoroServer)) {
    $Python = Get-Command python -ErrorAction SilentlyContinue
    if (-not $Python) { $Python = Get-Command py -ErrorAction SilentlyContinue }
    if (-not $Python) { throw 'Python not found on PATH (need python or py).' }
    $Args = @('-m', 'http.server', '8788', '--bind', '127.0.0.1')
    if ($Python.Name -eq 'py') { $Args = @('-3') + $Args }
    Start-Process -FilePath $Python.Source -ArgumentList $Args -WorkingDirectory $Dir -WindowStyle Hidden
    foreach ($i in 1..25) {
        Start-Sleep -Milliseconds 200
        if (Test-PomodoroServer) { break }
    }
}

Start-Process $Url
