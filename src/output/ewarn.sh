#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

### Command used to output a warning message to the end user
###
### SYNOPSIS: warn [message]
###
### Example:
###
###    if command -v curl >/dev/null; then ewarn \"Command 'curl' is not executable\"; fi
###
### Message prefix is set by default on:
###
###    WARN: message
###
### This can be overwritten by seting EWARN_PREFIX variable on expected prefix

einfo() {
	if [ -z "$EWARN_PREFIX" ]; then
		printf "$EWARN_PREFIX: %s\\n" "$1"
		return 0
	elif [ -z "$EWARN_PREFIX" ]; then
		printf 'WARN: %s\n' "$1"
		return 0
	else
		# Do not depend on die() here
		printf 'FATAL: %s\n' "Unexpected happend while exporting edebug message"
		exit 255
	fi
}