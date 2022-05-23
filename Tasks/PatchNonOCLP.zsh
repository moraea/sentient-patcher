major=12

cp -R $binaries/$major*/AirPortBrcmNIC.kext Build
/usr/libexec/PlistBuddy Build/AirPortBrcmNIC.kext/Contents/Info.plist -c 'add "IOKitPersonalities:Broadcom 802.11 PCI:IONameMatch:0" string pci14e4,4353'

cp -R $binaries/$major*/X86PlatformPlugin.kext Build
/usr/libexec/PlistBuddy Build/X86PlatformPlugin.kext/Contents/Info.plist -c 'add IOKitPersonalities:X86PlatformPlugin:IOParentMatch:IOPropertyMatch dict'
/usr/libexec/PlistBuddy Build/X86PlatformPlugin.kext/Contents/Info.plist -c 'add IOKitPersonalities:X86PlatformPlugin:IOParentMatch:IOPropertyMatch:plugin-type integer 1'

Binpatcher $binaries/$major*/libsystem_kernel.dylib Build/libsystem_kernel.dylib.patched '
symbol _fs_snapshot_create
return 0x0
symbol _fs_snapshot_root
return 0x0'

codesign -f -s - Build/libsystem_kernel.dylib.patched
chmod +x Build/libsystem_kernel.dylib.patched

Binpatcher $binaries/$major*/boot.efi Build/ffff.efi '
# and r8d,0xffef (CSR mask)
forward 0x4183e0ef

# or r8d,0xffff
write 0x4183c8ff

# test rax,rax (check result of call to get "csr-active-config")
backward 0x4885c0

# nop the subsequent jump
set +0x3
nop 0x2'

lipo -thin x86_64 $binaries/$major*/bluetoothd -o Build/bluetoothd.patched
rm -f Build/bluetoothdEnts.xml
codesign --dump --xml --entitlements Build/bluetoothdEnts.xml Build/bluetoothd.patched
Binpatcher Build/bluetoothd.patched Build/bluetoothd.patched '

# disable skipping devices named Bluetooth USB Host Controller
otool forward (?m)^.*?\[Found_USB_Dongle
otool forward (?m)^.*?CFStringCompare
otool forward (?m)^.*?je
nop 0x2

# disable skipping non-Broadcom/CSR devices
otool forward (?m)^.*?cmpl\t\$0xa12
otool forward (?m)^.*?jne
nop 0x2

# disable second Bluetooth USB Host Controller check
set 0x0
otool forward (?m)^.*?\[GetProductAndVendorID
otool forward (?m)^.*?CFStringCompare
otool forward (?m)^.*?je
nop 0x6

# TODO: might not be needed anymore (or never was in the first place?)
set 0x0
otool forward (?m)^.*?Third Party Dongle has the same address as the internal module
otool backward (?m)^.*?jmp
otool backward (?m)^.*?je
nop 0x2'
codesign -f -s - --entitlements Build/bluetoothdEnts.xml Build/bluetoothd.patched

lipo -thin x86_64 $binaries/$major*/BlueTool -o Build/BlueTool.patched
rm -f Build/BlueToolEnts.xml
codesign --dump --xml --entitlements Build/BlueToolEnts.xml Build/BlueTool.patched
Binpatcher Build/BlueTool.patched Build/BlueTool.patched '
# /etc/bluetool/SkipBluetoothAutomaticFirmwareUpdate --> /usr/sbin/BlueTool
forward 0x2f6574632f626c7565746f6f6c2f536b6970426c7565746f6f74684175746f6d617469634669726d7761726555706461746500
write 0x2f7573722f7362696e2f426c7565546f6f6c00'
codesign -f -s - --entitlements Build/BlueToolEnts.xml Build/BlueTool.patched

cp -R $binaries/$major*/com.apple.WebKit.WebContent.xpc Build
rm -f Build/WebEnts.plist
codesign --dump --entitlements Build/WebEnts.plist --xml Build/com.apple.WebKit.WebContent.xpc
defaults delete "$PWD/Build/WebEnts.plist" com.apple.private.security.message-filter
rm -rf Build/com.apple.WebKit.WebContent.xpc/Contents/PlugIns/MediaFormatReader.bundle
plutil -convert xml1 Build/WebEnts.plist
codesign -f -s - --entitlements Build/WebEnts.plist Build/com.apple.WebKit.WebContent.xpc

clang -fmodules -dynamiclib -I Build/non-metal-common/Utils Payloads/InstallerInject.m -o Build/InstallerInject.dylib
codesign -f -s - Build/InstallerInject.dylib