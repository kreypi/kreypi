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

efixme() {
	# Shellcompat: In case we don't have access to FUNCNAME
	# shellcheck disable=SC2128 # False trigger
	if [ "$FUNCNAME" != "efixme" ]; then
		# shellcheck disable=SC2178 # False trigger
		FUNCNAME="efixme"
	elif [ "$FUNCNAME" = "efixme" ]; then
		true
	else
		if command -v die >/dev/null; then
			die 255 "checking for efixme FUNCNAME"
		elif ! command -v die >/dev/null; then
			printf 'FATAL: %s\n' "Unexpected happend while checking efixme FUNCNAME"
			exit 255
		else
			printf 'FATAL: %s\n' "Unexpected happend while processing unexpected in efixme"
			exit 255
		fi
	fi

	# NOTICE: Ugly, but this way it doesn't have to process following if statement on runtime
	[ -z "$IGNORE_FIXME" ] && if [ -z "$EFIXME_PREFIX" ]; then
		printf "$EFIXME_PREFIX: %s\\n" "$1"
		return 0
	elif [ -z "$EFIXME_PREFIX" ]; then
		printf 'FIXME: %s\n' "$1"
		return 0
	else
		if command -v die >/dev/null; then
			die 255 "Unexpected happend while exporting fixme message"
		elif ! command -v die >/dev/null; then
			printf 'FATAL: %s\n' "Unexpected happend while exporting fixme message"
			exit 255
		else
			# shellcheck disable=SC2128 # False trigger
			printf 'FATAL: %s\n' "Unexpected happend while processing unexpected in $FUNCNAME"
			exit 255
		fi
	fi
}