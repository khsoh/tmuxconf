#!/bin/bash

. ~/.bash_profile

tmux -f /dev/null -L temp start-server \; show-options -g prefix| \
  sed -r -e "s/(.*)/set-option -g \1/g" > ~/.tmux.reset.conf

## == The following code is to get the notes for default tmux key bindings
echo pkey=\(\) > ~/.tmux_keynotes
echo pnote=\(\) >> ~/.tmux_keynotes

tmux -f /dev/null -L temp start-server \; list-keys > ~/.tmux_default_keymap

tmux -f /dev/null -L temp start-server \; list-keys -N | \
  sed -r \
  -e "s/[^ a-zA-Z0-9\-]/\\\\&/g" \
  -e "s/^\S+\s+(\S+)\s+(.*)$/pkey\+\=(\1)\npnote+=(\"\2\")/g" >> ~/.tmux_keynotes

. ~/.tmux_keynotes
## == end of getting the notes for default tmux key bindings into $pkey and $pnote

IFS=$'\n'
for line in $(cat ~/.tmux_default_keymap); do
  kb=`echo $line | grep -E -o "\-T prefix\s+(\S+)"|grep -E -o "\S+$"`
  if [[ -n $kb ]]; then
    ekb=${kb//\\/}

    ## There seems to be a bug in MacOS bash - the following array
    #  search cannot be implemented into a function
    idx=-1
    for (( i = 0; i < ${#pkey[@]}; i++ )); do
      if [[ "${pkey[$i]}" = "$ekb" ]]; then
        idx=$i
        break
      fi
    done

    if [[ $idx < 0 ]]; then
      echo $line >> ~/.tmux.reset.conf
    else
      echo ${line/-T prefix/-N \"${pnote[$idx]}\" -T prefix} >> ~/.tmux.reset.conf
    fi
  else
    echo $line >> ~/.tmux.reset.conf
  fi
done

