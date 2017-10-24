#----------------------------------------------------------------------------------
# Project Name      - $HOME/.profile
# Started On        - Thu 14 Sep 20:09:24 BST 2017
# Last Change       - Tue 24 Oct 13:41:48 BST 2017
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

[ -x /usr/bin/pactl ] && {
		while read -ra X; do
			if [[ "${X[@]%%: *}" == Default\ Source:\ * ]]; then
				printf -v PA_DEF_SOURCE "%s" "${X[2]}"
				export PA_DEF_SOURCE
			elif [[ "${X[@]%%: *}" == Default\ Sink:\ * ]]; then
				printf -v PA_DEF_SINK "%s" "${X[2]}"
				export PA_DEF_SINK
			fi
		done <<< "$(/usr/bin/pactl info short)"
}
