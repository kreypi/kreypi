#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

# Wrapper used to download file in location based on resources available on the system
efetch() {
	downloaderUrl="$1"
	downloaderTarget="$2"

	die fixme "Has to be rewritten to check pathname invidually"

	# Shell compatibility - FUNCNAME
	# shellcheck disable=SC2039 # FUNCNAME is undefined is irelevant since we are overwriting it.
	# shellcheck disable=SC2128 # invalid since we are using this for bash compatibility on shell
	if [ -z "$FUNCNAME" ]; then
		MYFUNCNAME="efetch"
	elif [ -n "$FUNCNAME" ]; then
		MYFUNCNAME="${FUNCNAME[0]}"
	else
		die 255 "shellcompat - FUNCNAME in efetch"
	fi

	# Core
	if [ -z "$downloaderUrl" ]; then
		die 2 "Function '$MYFUNCNAME' expects first argument with a hyperlink"
	elif [ -z "$downloaderTarget" ]; then
		die 2 "Function '$MYFUNCNAME' expects second argument pointing to a target to which we will export content of '$downloaderUrl'"
	elif [ -n "$downloaderUrl" ] && [ -n "$downloaderTarget" ]; then
		if [ ! -e "$downloaderTarget" ]; then
			case "$downloaderUrl" in
				http://*|https://*)
					if command -v wget >/dev/null; then
						fixme "If this is killed by the user it saves incomplete file which is unexpected"
						wget "$downloaderUrl" -O "$downloaderTarget" || die 1 "Unable to download '$downloaderUrl' in '$downloaderTarget' using wget"
					elif command -v curl >/dev/null; then
						curl -o "$downloaderTarget" "$downloaderUrl" || die 1 "Unable to download '$downloaderUrl' in '$downloaderTarget' using curl"
					elif command -v aria2c >/dev/null; then
						die fixme "Downloader aria2c is not supported by Kreypi"
					else
						die 255 "Unable to download hyperlink '$downloaderUrl' in '$downloaderTarget', unsupported downloader?"
					fi ;;
				git://*)
					if command -v git >/dev/null; then
						egit clone "$downloaderUrl" "$downloaderTarget" || die 256
					elif command -v aria2c >/dev/null; then
						die fixme "Unable to process '$downloaderUrl' using aria2c"
					else
						die 256 "efetch '$downloaderUrl'"
					fi
				*) die 2 "hyperlink '$downloaderUrl' is not supported, fixme?"
			esac
		elif [ -e "$downloaderTarget" ]; then
			debug "Pathname '$downloaderTarget' already exists, skipping download"
		else
			die 255 "downloader cheking for target '$downloaderTarget'"
		fi
	fi

	unset target url
}
