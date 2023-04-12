#!/usr/bin/env bash

# shellcheck disable=2034
XDG_CONFIG_HOME="${HOME}/.config"

info() {
	printf "\033[36m%s\033[0m\n" "$*" >&2
}

warn() {
	printf "\033[33mWarning: %s\033[0m\n" "$*" >&2
}

error() {
	printf "\033[31mError: %s\033[0m\n" "$*" >&2
	exit 1
}

is_installed() {
	if [[ ${ZSH_VERSION} ]]; then
        whence -cp "$1" > /dev/null 2>&1
    else  # bash
        type -P "$1" > /dev/null 2>&1
    fi
}

is_docker() {
	if [ -f /.dockerenv ]; then
		return 0
	fi
	return 1  # echo "I'm living in real world!";
}

download() {
	local src=$1
	local dest=$2
	local opts=(--silent --fail --retry-connrefused --retry 5 --location -H "Accept: application/octet-stream")
	if [ -n "${dest}" ]; then
		opts+=(--create-dirs --output "${dest}")
	fi
	curl "${opts[@]}" "${src}"
}


tail_output() {
	# example: sudo apt-get update | tail_output 10
	i=0
	j=0
	
	[ "$#" = 1 ] || { >&2 echo "The number of lines should be provided"; exit 9; }
	nlines=$1

	while IFS= read -r line; do
		all="$all
	$line"

		i=$((i+1))
		if [ "$i" -ge "$nlines" ]; then
			all="${all#*
	}"
		fi

		j=$((j+1))
		if [ "$j" -lt "$nlines" ]; then
			printf '\033[%sA' "$j"
		elif [ "$j" -gt "$nlines" ]; then
			printf '\033[%sA' "$nlines"
		else
			printf '\033[%sA' "$((nlines-1))"
		fi
		
		printf '\033[0;33m\t%s\n\033[0m' "$all"
	done < /dev/stdin
}

tail_lines() {
	# save cursor position
	tput sc
	tput ed

	# if is a number
	# `<->' is a special zsh pattern to match any number, an extension of forms like `<1-100>' which matches any number in the range 1 to 100 inclusive
	# https://zsh.sourceforge.io/Guide/zshguide03.html
	if [ -z "$1" ]; then
		nlines=5
	else
		nlines=$1
	fi

	YELLOW=$(tput setaf 3)
	NORMAL_COLOR=$(tput sgr0)

	while IFS= read -r line; do
		# restore cursor position
		tput rc
		if [ -z "$output" ]; then
			output="  $line"
		else
			output=`echo "$output\n  $line" | tail -n $nlines`
		fi
		printf -- "${YELLOW}$output${NORMAL_COLOR}\n"
	done < /dev/stdin

	tput rc
	tput ed || tput 'cd'
}
