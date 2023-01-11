target="$1"

# kmutil breaks when / referenced with /Volumes/..
target="$(readlink $target)"

mount -uw "$target"

while read extension
do
	echo delete "$extension"
	rm -rf "$target/$extension"
done < Payloads/NonMetalDelete.txt

cp -R Build/SystemOverlay/System/Library/Extensions/ "$target/System/Library/Extensions"

chown -R root:wheel "$target/System/Library/Extensions"
chmod -R 755 "$target/System/Library/Extensions"

kmutil install --update-all --update-preboot --volume-root "$target/"

set +e
cp -R Build/SystemOverlay/ "$target/"
set -e

sync
reboot