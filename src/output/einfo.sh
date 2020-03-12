#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

### Command used to output relevant information for end-user
###
### SYNOPSIS: einfo [message]
###
### Example:
###
###    einfo "Downloading some_url in some_path"
###    wget some_url -O some_path

einfo() {
	if [ -z "$EINFO_PREFIX" ]; then
		printf "$EINFO_PREFIX: %s\\n" "$1"
		return 0
	elif [ -z "$EINFO_PREFIX" ]; then
		printf 'INFO: %s\n' "$1"
		return 0
	else
		# Do not depend on die() here
		printf 'FATAL: %s\n' "Unexpected happend while exporting edebug message"
		exit 255
	fi
}