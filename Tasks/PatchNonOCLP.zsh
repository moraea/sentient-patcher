major=13

cp -R $binaries/$major*/AirPortBrcmNIC.kext Build
/usr/libexec/PlistBuddy Build/AirPortBrcmNIC.kext/Contents/Info.plist -c 'add "IOKitPersonalities:Broadcom 802.11 PCI:IONameMatch:0" string pci14e4,4353'