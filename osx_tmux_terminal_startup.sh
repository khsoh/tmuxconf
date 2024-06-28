#!/usr/bin/env bash

start_terminal_and_run_tmux() {
	osascript <<-EOF
	tell application "Terminal"
		if not (exists window 1) then reopen
		activate
		set winID to id of window 1
		do script "tmux" in window id winID
	end tell
	EOF
}

main() {
	start_terminal_and_run_tmux
}
main
