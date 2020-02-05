#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

:'
Command used to output a FIXME message for features that are not yet implmented

SYNOPSIS: fixme [message]

Example:

    if command -v wget >/dev/null; then
        fixme "only wget is currently supported, add more options for download"
        wget someurl -O somepath
    elif command -v curl >/dev/null; then
        die fixme "curl is not implemented"
    else
        die 255 "example of wget to fixme intro"
    fi
    
Messages are enabled by default

Can be disabled by seting variable IGNORE_FIXME on non-zero'


# Failed experiment
# thing() {
# 	arg="$1"

# 	# FIXME: Expecting EFIXME_PREFIX set based on 'arg' variable
# 	if [ -z "$EDEBUG_PREFIX" ]; then
# 		printf "$EDEBUG_PREFIX: %s\\n" "$1"
# 		return 0
# 	# FIXME: Expecting EFIXME_PREFIX set based on 'arg' variable
# 	elif [ -z "$EDEBUG_PREFIX" ]; then
# 		printf "${arg^^}: %s\\n" "$1"
# 		return 0
# 	else
# 		# Do not depend on die() here
# 		printf 'FATAL: %s\n' "Unexpected happend while exporting fixme message"
# 		exit 255
# 	fi
# }

# efixme_new() {
# 	thing efixme
# }


efixme() {
	# Ugly, but this way it doesn't have to process following if statement on runtime
	[ -z "$IGNORE_FIXME" ] && if [ -z "$EFIXME_PREFIX" ]; then
		printf "$EFIXME_PREFIX: %s\\n" "$1"
		return 0
	elif [ -z "$EFIXME_PREFIX" ]; then
		printf 'FIXME: %s\n' "$1"
		return 0
	else
		# Do not depend on die() here
		printf 'FATAL: %s\n' "Unexpected happend while exporting fixme message"
		exit 255
	fi
}