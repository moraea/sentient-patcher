#!/bin/zsh

set -e
cd "$(dirname "$0")"

rm -rf Build
mkdir Build

cd Build

if test -n "$MORAEA_LOCAL_DEPENDENCIES"
then
	cp -R ../../non-metal-common .
	cp -R ../../non-metal-binaries .
	cp -R ../../non-metal-frameworks .
else
	git clone https://github.com/moraea/non-metal-common
	git clone https://github.com/moraea/non-metal-binaries
	git clone https://github.com/moraea/non-metal-frameworks
fi

chflags hidden non-metal-common non-metal-binaries non-metal-frameworks

non-metal-common/Build.tool

non-metal-frameworks/Dependencies.tool
non-metal-frameworks/Build.tool