target="$1"

mount -uw "/Volumes/$target/"

rm -f "/Volumes/$target/System/Library/PrivateFrameworks/SkyLight.framework/Versions/A/SkyLight"
rm -f "/Volumes/$target/System/Library/Frameworks/CoreDisplay.framwork/Versions/A/CoreDisplay"
rm -f "/Volumes/$target/System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore"

sync
reboot