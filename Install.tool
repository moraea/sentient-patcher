#!/bin/zsh

set -e
cd "$(dirname "$0")"

function promptList
{
	osascript -e 'on run argList
tell app "Terminal" to choose from list items 2 thru end of argList with prompt item 1 of argList
set output to result
if output is false then error number -128
return output
end' "$@"
}

PATH+=:"$PWD/Build/non-metal-common/Build"
binaries=Build/non-metal-binaries

source Tasks/PatchCommon.zsh
source Tasks/StageCommon.zsh

mode="$(promptList 'install mode' 'usb' 'shove')"

source Tasks/PatchNonOCLP.zsh
source Tasks/StageNonOCLP.zsh

if test "$mode" = 'usb'
then
	sudo zsh -e Tasks/InstallDisk.zsh
elif test "$mode" = 'shove'
then
	sudo zsh -e Tasks/InstallShove.zsh
fi