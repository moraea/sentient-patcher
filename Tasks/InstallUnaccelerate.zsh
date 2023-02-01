target="$1"

mount -uw "$target"

rm -f "$target/System/Library/PrivateFrameworks/SkyLight.framework/Versions/A/SkyLight"
rm -f "$target/System/Library/Frameworks/CoreDisplay.framework/Versions/A/CoreDisplay"
rm -f "$target/System/Library/Frameworks/QuartzCore.framework/Versions/A/QuartzCore"

sync

killall -9 WindowServer loginwindow