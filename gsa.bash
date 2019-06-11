#!/bin/env bash
# Copyright 2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SGSATRPERROR_() { # Run on script error.
	local RV="$?"
	echo "$RV"
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs %s ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "gsa.bash" "${3:-VALUE}" "${1:-LINENO}" "${2:-BASH_COMMAND}"
	exit 179
}

_SGSATRPEXIT_() { # Run on exit.
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SGSATRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "gsa.bash" "$RV"
 	exit 178 
}

_SGSATRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "gsa.bash" "$RV"
 	exit 177 
}

trap '_SGSATRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SGSATRPEXIT_ EXIT
trap _SGSATRPSIGNAL_ HUP INT TERM 
trap _SGSATRPQUIT_ QUIT 

_GSA_() {
	(git submodule add $3 https://github.com/sdrausty/$2 $1) || (echo ; echo "Cannot update $2: continuing...") 
}

_GSA_ docs docsTermuxArch ""
_GSA_ docs/imgs imgsTermuxArch "-f"
_GSA_ gens gensTermuxArch ""
_GSA_ scripts scriptsTermuxArch ""
_GSA_ scripts/frags/dfa dfa "-f"

#EOF
