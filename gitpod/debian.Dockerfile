# Created for gitpod by Jacob Hrbek <kreyren@rixotstudio.cz> under GPL-3 license (https://www.gnu.org/licenses/gpl-3.0.en.html) in 2020
FROM debian:stable

# FIXME: Outputs `gitpod@ws-ce281d58-997b-44b8-9107-3f2da7feede3:/workspace/gitpod-tests1$` in terminal
# FIXME: Add hadolint executable
# FIXME: We can use /bin/sh instead of /bin/bash to get minor optimization

# To avoid bricked workspaces (https://github.com/gitpod-io/gitpod/issues/1171)
ENV DEBIAN_FRONTEND=noninteractive

USER root

ENV LANG=en_US.UTF-8
ENV LC_ALL=C

# Add 'gitpod' user
## FIXME: Sanitize
RUN useradd \
	--uid 33333 \
	--create-home --home-dir /home/gitpod \
	--shell /bin/bash \
	--password gitpod \
	gitpod || exit 1

RUN true \
  # FIXME: Sanitize
  && apt update \
  && if apt list --installed | grep -qP "^shellcheck\s{1}-.*"; then apt install -y shellcheck; fi

# Export PS1
RUN if ! grep -qP "^PS1=\".*\"" "$HOME/.bashrc"; then printf '%s\n' 'export PS1="\033[1m\e[38;5;201m[ \t : \w : EXIT \$? ]\033[0m\e[38;5;011m\n\u@gitpod \\$ \[$(tput sgr0)\]"' >> "$HOME/.bashrc"; fi