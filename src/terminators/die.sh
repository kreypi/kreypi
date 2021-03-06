#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

### function used to terminate the program if provided error code is non-zero and output a custom message with options for translate
###
### SYNOPSIS: die [error_code] (message)
###
### This command is made to be compatible with POSIX sh and bash
###
### ERROR CODES:
###  0 - General true
###  1 - General false
###  2 - Syntax error
###  3 - Permission issue
###  126 - Not executable
###  130 - Killed by the end-user
###  255 - Unexpected
###  ping - output ping (used for development returns 1)
###  fixme - Used to output fatal error about unimplemented feature (returns 1)
###
### Example:
###
###  if ! command -v wget >/dev/null; then die 126 "Command wget is not executable"; fi
###
###  would result in `FATAL: Command wget is not executable` on a system with DIE_PREFIX="FATAL:" and non-executable wget in PATH
###
### Prefix:
###
###  Prefix of this output can be defined by exporting DIE_PREFIX environment variable
###
###  for example: DIE_PREFIX="hey" would result in errors alike: "hey error_message_here"
###
###  This is used for end-user customization of the output
###
### References:
###  - Exit codes - http://tldp.org/LDP/abs/html/exitcodes.html#EXITCODESREF

# Define DIE_PREFIX
if [ -z "$DIE_PREFIX" ]; then
	case $LANG in
		cz*) DIE_PREFIX="FATALNÍ:" ;;
		sk*) DIE_PREFIX="ČOBOLO:" ;;
		en*|*) DIE_PREFIX="FATAL:"
	esac
elif [ -z "$DIE_PREFIX" ]; then
	true # DIE_PREFIX set by the end-user
else
	# Do not use die here since it is not sourced yet
	printf 'FATAL: %s\n' "Unexpected happend in DIE_PREFIX for die.sh"
	exit 255
fi

die() {
	# Capture arguments
	err_code="$1"
	message="$2"

	# POSIX compatibility for FUNCNAME
	if [ -z "$FUNCNAME" ]; then
		# INFO: This has to be changed in case function name changes!
		MYFUNCNAME="die"
	elif [ -n "$FUNCNAME" ]; then
		MYFUNCNAME="${FUNCNAME[0]}"
	else
		# Do not use die here since it is not sourced yet
		printf 'FATAL: %s\n' "Unexpected happend in die() - FUNCNAME"
		exit 255
	fi

	# HELPER: Handle the output of the command for those that are outputing message that is not hard-codded
	die_output() {
		if [ -n "$DIE_message" ]; then
			printf "$DIE_PREFIX %s\\n" "$DIE_message" 1>&2
		elif [ -z "$DIE_message" ]; then
			die_message
		else
			die 255 "$MYFUNCNAME, $err_code"
		fi

		# Allows unsetting all variables defined in 'masterUnset' prior to exit
		[ -n "$masterUnset" ] && unset masterUnset

		exit "$err_code"
	}

	case "$err_code" in
		0|true)
			edebug "Function $MYFUNCNAME returned true for $*"

			# Do not terminate if error code '0' is used
			return 0
		;;
		1|false) # False
			die_message() {
				case $LANG in
					en*) printf "$DIE_PREFIX %s\\n" "Function $MYFUNCNAME returned false" ;;
					*) printf "$DIE_PREFIX %s\\n" "Function $MYFUNCNAME returned false"
				esac
			}

			die_output
		;;
		2) # Syntax err
			die_message() {
				case $LANG in
					en*|*) printf "$DIE_PREFIX %s\\n" "Function $MYFUNCNAME returned $err_code"
				esac
			}

			die_output
		;;
		3) # Permission issue
			die_message() {
				case $LANG in
					en*|*) printf "$DIE_PREFIX %s\\n" "Unable to elevate root access $([ -n "$(id -u)" ] && printf '%s\n' "from UID '$(id -u)'")"
				esac
			}

			die_output
		;;
		126) # Not executable
			die_message() {
				case $LANG in
					en*) printf "$DIE_PREFIX %s\\n" "Error code $err_code has been parsed in $MYFUNCNAME which is used for not executable"
				esac
			}

			die_output
		;;
		130) # Killed by user i.e used 'CTRL+C'
			die_message() {
				case $LANG in
					en*) printf "$DIE_PREFIX %s\\n" "Error code $err_code has been parsed in $MYFUNCNAME indicating that command was killed by user"
				esac
			}

			die_output
		;;
		255) # Unexpected
			die_message() {
				case $LANG in
					en*) printf "$DIE_PREFIX %s\\n" "Unexpected result in '$DIE_message'" ;;
					*) printf "$DIE_PREFIX %s\\n" "Unexpected result in '$DIE_message'"
				esac
			}

			die_output
		;;
		ping) # Ping used for development
			printf "$DIE_PREFIX %s\\n" "! ! ! P I N G ! ! !"
			[ -n "$masterUnset" ] && unset masterUnset
			exit 1
		;;
		help|--help|-help|pomoc|--pomoc|-pomoc)
			case $LANG in
				cz-*) printf '%s\n' ;;
				en-*|*) printf '%s\n' \
					"Usage: die [ERROR_CODE] \"(message)\"" \
					"Assertion wrapper with ability to specify exit code through supported ERROR_CODE and message" \
					"" \
					"ERROR_CODE:" \
					"  0 - General true" \
					"  1 - General false" \
					"  2 - Syntax error" \
					"  3 - Permission issue" \
					"  126 - Not executable" \
					"  130 - Killed by the end-user" \
					"  255 - Unexpected" \
					"  ping - output ping (used for development returns 1)" \
					"  fixme - Used to output fatal error about unimplemented feature (returns 1)" \
					"" \
					"Report bugs to: bug-kreypi@rixotstudio.cz"
			esac

			exit 1 # Exit with 1 in case this is done by mistake
		;;
		-h|h) # Used to output basic usage
			case $LANG in
				cz-*) printf '%s\n' \
					"Použití: die [ERROR_CODE] (message)" \
					"Zkus 'die --help' pro více informací" ;;
				en-*|*) printf '%s\n' \
					"Usage: die [ERROR_CODE] (message)" \
					"Try 'die --help' for more informations"
			esac

			exit 1 # Exit with 1 in case this is done by mistake
		*) # In case wrong syntax was used
			case $LANG in
				en*) printf "$DIE_PREFIX %s\\n" "Wrong argument '$err_code' has been parsed in die()"
			esac

			exit 2
	esac

	# Master Unset
	[ "$DIE_PREFIX" = "FATAL:" ] && unset DIE_PREFIX
	unset err_code DIE_message MYFUNCNAME
}