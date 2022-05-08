major=12

cp -R $binaries/$major*/AirPortBrcmNIC.kext Build/AirPortBrcmNIC.kext

/usr/libexec/PlistBuddy Build/AirPortBrcmNIC.kext/Contents/Info.plist -c 'add "IOKitPersonalities:Broadcom 802.11 PCI:IONameMatch:0" string pci14e4,4353'

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

clang -fmodules -dynamiclib -I Build/non-metal-common/Utils Payloads/InstallerInject.m -o Build/InstallerInject.dylib
codesign -f -s - Build/InstallerInject.dylib