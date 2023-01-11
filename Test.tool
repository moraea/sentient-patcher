#!/bin/zsh

export MORAEA_LOCAL_DEPENDENCIES=1
export AUTO_TARGET=13
export AUTO_QC=11
export TARGET_VOLUME=/Volumes/131b3

set -e
cd "$(dirname "$0")"

export SENTIENT_PATCHER=1

rm -rf Build
mkdir Build

cp -R ../non-metal-common Build
cp -R ../non-metal-binaries Build
cp -R ../non-metal-frameworks Build

chflags hidden Build/non-metal-common Build/non-metal-binaries Build/non-metal-frameworks

Build/non-metal-common/Build.tool
Build/non-metal-frameworks/Dependencies.tool
Build/non-metal-frameworks/Build.tool

mode=ShoveAll
if [[ "$1" = userspace ]]
then
	mode=ShoveUserspace
fi
if [[ "$1" = unaccelerate ]]
then
	mode=Unaccelerate
fi

PATH+=:"$PWD/Build/non-metal-common/Build"
binaries=Build/non-metal-binaries

source Tasks/PatchCommon.zsh
source Tasks/StageCommon.zsh
source Tasks/PatchNonOCLP.zsh
source Tasks/StageNonOCLP.zsh

echo "*** $mode ***"
sudo zsh -e Tasks/Install$mode.zsh "$TARGET_VOLUME"