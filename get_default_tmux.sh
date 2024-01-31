#!/bin/bash
/opt/homebrew/bin/tmux -f /dev/null -L temp start-server \; show-options -g prefix| \
  sed -r -e "s/(.*)/set-option -g \1/g" > ~/.tmux.reset.conf

/opt/homebrew/bin/tmux -f /dev/null -L temp start-server \; list-keys | \
  sed -r \
  -e "s/bind-key(\s+)([\"#~\$])(\s+)/bind-key\1\'\2\'\3/g" \
  -e "s/bind-key(\s+)([\'])(\s+)/bind-key\1\"\2\"\3/g" \
  -e "s/bind-key(\s+)([;])(\s+)/bind-key\1\\\\\2\3/g" \
  -e "s/command-prompt -I #([SW])/command-prompt -I \"#\1\"/g" \
  >> ~/.tmux.reset.conf
