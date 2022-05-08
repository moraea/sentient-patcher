overlay=Build/SystemOverlay

mkdir -p $overlay/System/Library/Extensions/IO80211FamilyLegacy.kext/Contents/PlugIns
cp -R Build/AirPortBrcmNIC.kext $overlay/System/Library/Extensions/IO80211FamilyLegacy.kext/Contents/PlugIns

# PatchBluetooth
# PatchLPM
# PatchWeb

overlay=Build/RamdiskOverlay
rm -rf $overlay

mkdir -p $overlay/usr/lib/system
cp Build/libsystem_kernel.dylib.patched $overlay/usr/lib/system/libsystem_kernel.dylib

mkdir -p $overlay/sbin
cp Payloads/RamdiskFakeReboot.bash $overlay/sbin/reboot
chmod +x $overlay/sbin/reboot

mkdir -p $overlay/System/Library/Frameworks
ln -s '/mnt1/System/Library/Frameworks/KernelManagement.framework' $overlay/System/Library/Frameworks

cp Build/ffff.efi $overlay

cp Payloads/NonMetalDelete.txt $overlay/Delete.txt

cp -R Build/SystemOverlay $overlay

overlay=Build/DataOverlay
rm -rf $overlay

booterOutFolder="$overlay/macOS Install Data/UpdateBundle/AssetData/boot/Firmware/System/Library/CoreServices"
mkdir -p "$booterOutFolder"
cp Build/ffff.efi "$booterOutFolder/bootbase.efi"

overlay=Build/InstallerOverlay
rm -rf $overlay
mkdir $overlay

cp Build/InstallerInject.dylib $overlay
cp Payloads/InstallerWrapper.bash $overlay
chmod +x $overlay/InstallerWrapper.bash

cp Payloads/InstallerPost.bash $overlay

mkdir -p $overlay/System/Library/CoreServices
cp Build/ffff.efi $overlay/System/Library/CoreServices/boot.efi

cp -R Build/DataOverlay $overlay
cp -R Build/RamdiskOverlay $overlay