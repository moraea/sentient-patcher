#!/bin/zsh

set -e
cd "$(dirname "$0")"

# TODO: only migrated minimal zoe/12/shove so far

PATH+=:"$PWD/Build/non-metal-common/Build"
binaries=Build/non-metal-binaries

source Tasks/PatchKexts.zsh
source Tasks/StageSystem.zsh

sudo zsh Tasks/InstallShove.zsh