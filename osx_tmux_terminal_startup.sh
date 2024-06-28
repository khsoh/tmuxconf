#!/usr/bin/env bash

start_terminal_and_run_tmux() {
	osascript >/dev/null 2>&1 <<-EOF
	tell application "Terminal"
		if not (exists window 1) then reopen
		activate
		set winID to id of window 1
		do script "tmux 2>/dev/null" in window id winID
	end tell
	return
	EOF
}

main() {
	start_terminal_and_run_tmux
}
main
