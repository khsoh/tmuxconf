#!/bin/zsh

. ~/.zprofile

tmux -f /dev/null -L temp start-server \; show-options -g prefix| \
  sed -r -e "s/(.*)/set-option -g \1/g" > ~/.tmux.zsh.reset.conf

## == The following code is to get the notes for default tmux key bindings
echo declare -A pkeynotes > ~/.tmux_zsh_keynotes
echo pkey=\(\) >> ~/.tmux_zsh_keynotes

tmux -f /dev/null -L temp start-server \; list-keys > ~/.tmux_zsh_default_keymap

tmux -f /dev/null -L temp start-server \; list-keys -N | \
  sed -r \
  -e "s/[^ \/\=\?\:\.\,\&\!\$a-zA-Z0-9\-]/\\\\&/g" \
  -e "s/^\S+\s+(\S+)\s+(.*)$/pkeynotes[\"\1\"]=\"\2\"/g" >> ~/.tmux_zsh_keynotes

. ~/.tmux_zsh_keynotes

IFS=$'\n'       # make newlines the only separator
for line in $(cat ~/.tmux_zsh_default_keymap); do
  kb=`echo $line | grep -E -o "\-T prefix\s+(\S+)"|grep -E -o "\S+$"`
  if [[ -n $kb ]]; then
    ekb=${kb:gs/\\//}

    if [[ ${pkeynotes[(Ie)"$kb"]} ]]; then
      echo "${line/-T prefix/-N \"${pkeynotes[\"$kb\"]}\" -T prefix}" >> ~/.tmux.zsh.reset.conf
    elif [[ ${pkeynotes[(Ie)"$ekb"]} ]]; then
      echo "${line/-T prefix/-N \"${pkeynotes[\"$ekb\"]}\" -T prefix}" >> ~/.tmux.zsh.reset.conf
    else
      # No notes - so skip here
      echo "${line}" >> ~/.tmux.zsh.reset.conf
    fi
  else
    echo $line >> ~/.tmux.zsh.reset.conf
  fi
done

