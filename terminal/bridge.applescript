-- Pomodoro terminal bridge — called by the `pomodoro` shell command.
-- Usage: osascript bridge.applescript [toggle|start|pause|skip|reset|status]
-- Finds the Pomodoro tab in Safari or Chrome and calls the page's window.pomodoro API.
on run argv
	set action to item 1 of argv

	if action is "status" then
		set js to "window.pomodoro ? window.pomodoro.status() : 'STALE'"
	else if action is "toggle" or action is "skip" or action is "reset" then
		set js to "window.pomodoro ? (window.pomodoro." & action & "(), window.pomodoro.status()) : 'STALE'"
	else if action is "start" then
		set js to "window.pomodoro ? (window.pomodoro.state().running || window.pomodoro.toggle(), window.pomodoro.status()) : 'STALE'"
	else if action is "pause" then
		set js to "window.pomodoro ? (window.pomodoro.state().running && window.pomodoro.toggle(), window.pomodoro.status()) : 'STALE'"
	else
		return "UNKNOWN ACTION"
	end if

	set foundTab to false
	set resultText to ""

	with timeout of 8 seconds
		try
			if application "Safari" is running then
				tell application "Safari"
					repeat with w in windows
						repeat with t in tabs of w
							try
								if (URL of t contains "127.0.0.1:8788") or (name of t contains "— Pomodoro") then
									set foundTab to true
									try
										set r to do JavaScript js in t
										if r is not missing value then set resultText to r as text
									end try
								end if
							end try
						end repeat
					end repeat
				end tell
			end if
		end try
	end timeout

	with timeout of 8 seconds
		try
			if application "Google Chrome" is running then
				tell application "Google Chrome"
					repeat with w in windows
						repeat with t in tabs of w
							try
								if (URL of t contains "127.0.0.1:8788") or (title of t contains "— Pomodoro") then
									set foundTab to true
									try
										set r to execute javascript js in t
										if r is not missing value then set resultText to r as text
									end try
								end if
							end try
						end repeat
					end repeat
				end tell
			end if
		end try
	end timeout

	if resultText is not "" then
		if resultText is "STALE" then
			return "STALE TAB — the open Pomodoro page predates the control API; refresh it once (Cmd+R), then retry."
		end if
		return resultText
	end if
	if foundTab then
		return "BLOCKED — tab found but could not run JS. Allow your terminal to control the browser (approve the macOS prompt, or System Settings ▸ Privacy & Security ▸ Automation) and enable 'Allow JavaScript from Apple Events' in the browser menu (Safari: Develop menu; Chrome: View ▸ Developer), then retry."
	end if
	return "NO TAB — open the Pomodoro page in Safari or Chrome first."
end run
