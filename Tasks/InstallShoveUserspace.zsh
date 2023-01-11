target="$1"
mount -uw "$target"

s=Build/SystemOverlay

set +e
for f in Frameworks PrivateFrameworks
do
	for a in CoreDisplay IOSurface QuartzCore SkyLight
	do
		cp $s/System/Library/$f/$a.framework/Versions/A/${a}Old.dylib "$target/System/Library/$f/$a.framework/Versions/A/"
		cp $s/System/Library/$f/$a.framework/Versions/A/$a "$target/System/Library/$f/$a.framework/Versions/A/"
		codesign -fs - "$target/System/Library/$f/$a.framework/Versions/A/${a}Old.dylib"
		codesign -fs - "$target/System/Library/$f/$a.framework/Versions/A/${a}"
	done
done
set -e

sync

killall -9 WindowServer loginwindow