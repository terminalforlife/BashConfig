#----------------------------------------------------------------------------------
# Project Name      - $HOME/.profile
# Started On        - Thu 14 Sep 20:09:24 BST 2017
# Last Change       - Sat 21 Oct 14:17:24 BST 2017
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

[ -x /usr/bin/pactl ] && {
	export PA_DEF_SOURCE=$(
		while read -ra X; do
			[[ "${X[@]%%: *}" == Default\ Source:\ * ]] && echo "${X[2]}"
		done <<< "$(/usr/bin/pactl info short)"
	)

	export PA_DEF_SINK=$(
		while read -ra X; do
			[[ "${X[@]%%: *}" == Default\ Sink:\ * ]] && echo "${X[2]}"
		done <<< "$(/usr/bin/pactl info short)"
	)
}
