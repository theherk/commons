#!/usr/bin/env sh
i3-msg 'workspace 1: browse; append_layout ~/.i3/layout/browse.json'
i3-msg 'workspace 2: emacs; append_layout ~/.i3/layout/emacs.json'
i3-msg 'workspace 3: term; append_layout ~/.i3/layout/term.json'
i3-msg 'workspace 0: comms; append_layout ~/.i3/layout/comms.json'
chromium&
emacs&
slack&
urxvt&
