#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html) license

: '
Command used to output verbose messages for development that are considered as too many informations for the end-user

SYNOPSIS: edebug "[message]"

Example:

		if command -v wget >/dev/null; then
			edebug "Executing command wget to download some_url in some_path"
			wget some_url -O some_path
		fi
'

edebug() {
	# Ugly, but this way it doesn't have to process following if statement on runtime
	[ -n "$DEBUG" ] && if [ -z "$EDEBUG_PREFIX" ]; then
		printf "$EDEBUG_PREFIX: %s\\n" "$1"
		return 0
	elif [ -z "$EDEBUG_PREFIX" ]; then
		printf 'DEBUG: %s\n' "$1"
		return 0
	else
		# Do not depend on die() here
		printf 'FATAL: %s\n' "Unexpected happend while exporting edebug message"
		exit 255
	fi
}