#!/usr/bin/env zsh

if [ ! -z ${TMUX} ]; then
  # TMUX variable is set - so nothing to do
  exit 0
fi

NERDFONT="FiraMono Nerd Font Mono"
CHECKNERDFONT=0
## Test code to check presence of Nerd font - this is skipped because
#    CHECKNERDFONT is 0
if [[ ! -z ${CHECKNERDFONT} && ${CHECKNERDFONT} -ne 0 ]]; then
  XFONT=$(osascript -e "
  use framework \"AppKit\"
  set fontFamilyNames to (current application's NSFontManager's sharedFontManager's availableFontFamilies) as list
  if fontFamilyNames contains \"${NERDFONT}\" then log \"${NERDFONT}\"
  " 2>&1 )


  if [[ ${XFONT} != ${NERDFONT} ]]; then
    >&2 echo "Cannot find ${NERDFONT} - please install Nerd fonts to improve look of tmux!!"
    >&2 echo "Font will not be changed for terminal"
    exit 1
  fi

fi

TMUXTTY=$(tty)
osascript -e "
tell application \"Terminal\"
  set W to the first window whose tty of tab 1 is \"${TMUXTTY}\"
  set font of W to \"${NERDFONT}\"
end tell
"

