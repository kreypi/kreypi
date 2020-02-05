#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2020 under GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html) license

while [ $# -gt 1 ]; do case "$1" in
	--source-all)
	--help|-help|-h|help)
		printf '%s\n' "FIXME: HELP MESSAGE" ;;
	*)
		printf 'FATAL: %s\n' "Unsupported argument '$1' has been parsed in kreypi"
		exit 255
esac; done