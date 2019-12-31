#!/bin/sh

#----------------------------------------------------------------------------------
# Project Name      - BashConfig/devutils/hashes.sh
# Started On        - Mon 30 Dec 23:37:43 GMT 2019
# Last Change       - Tue 31 Dec 00:04:53 GMT 2019
# Author E-Mail     - terminalforlife@yahoo.com
# Author GitHub     - https://github.com/terminalforlife
#----------------------------------------------------------------------------------

set -e
. /usr/lib/tflbp-sh/ChkDep
set +e

ChkDep md5sum

cd "$HOME/GitHub/terminalforlife/Personal/BashConfig/source"

1> ../md5sum
for CurFile in .* * .shplugs/*; do
	md5sum "$CurFile" 2> /dev/null 1>> ../md5sum
done
