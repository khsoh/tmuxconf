#!/usr/bin/env bash

start_terminal_and_run_tmux() {
	osascript <<-EOF
	tell application "Terminal"
		if not (exists window 1) then reopen
		activate
		set winID to id of window 1
		do script "tmux new-session -A" in window id winID
	end tell
	EOF
}

resize_window_to_half_screen() {

	## Get the main display resolution
	NIXRUNPATH=/run/current-system/sw/bin
	JQ=$NIXRUNPATH/jq
	SED=$NIXRUNPATH/sed
	DISPJS=$(system_profiler SPDisplaysDataType -json|$JQ '.SPDisplaysDataType')
	if [[ $(echo $DISPJS|$JQ 'length') -gt 0 ]]; then
		eval $(echo $DISPJS | $JQ '.[0].spdisplays_ndrvs.[] | select (.spdisplays_main == "spdisplays_yes") | ._spdisplays_resolution' | $SED -rn 's/"([0-9]+)\s*x\s*([0-9]+).*$/XX=\1;YY=\2/p')

		## Compute the coordinates to position the terminal window in the main display.
		## So, this works properly even in a multi-monitor setup.
		TOPLEFTX=0
		TOPLEFTY=25
		BOTRIGHTX=$(( XX / 2 ))	# Setup in the left half of main display
		BOTRIGHTY=$(( YY - 10 ))

		osascript <<-EOF
		tell application "Terminal"
			set winID to id of window 1
			set bounds of window id winID to {$TOPLEFTX, $TOPLEFTY, $BOTRIGHTX, $BOTRIGHTY}
		end tell
		EOF
	else
		## The following code is needed for VM installation because
		## SPDisplaysDataType is absent from system_profiler for VMs
		osascript <<-EOF
		tell application "Terminal"
			set winID to id of window 1
			tell application "Finder"
				set halfDesktopSize to bounds of window of desktop
			end tell
			set item 3 of halfDesktopSize to (item 3 of halfDesktopSize div 2)
			set bounds of window id winID to halfDesktopSize
		end tell
		EOF
	fi
}

main() {
	start_terminal_and_run_tmux
	resize_window_to_half_screen
}
main
