# TODO: move non-non-Metal binaries to their own repo instead of this weird "put them in the non-metal-binaries repo but gitignore them" thing i'm doing right now

overlay=Build/SystemOverlay

mkdir -p $overlay/System/Library/Extensions/IO80211FamilyLegacy.kext/Contents/PlugIns
cp -R Build/AirPortBrcmNIC.kext $overlay/System/Library/Extensions/IO80211FamilyLegacy.kext/Contents/PlugIns

cp -R $binaries/10.13*/AppleHDA.kext $overlay/System/Library/Extensions
cp -R $binaries/10.13*/nvenet.kext $overlay/System/Library/Extensions