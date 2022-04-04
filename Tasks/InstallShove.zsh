# TODO: simple, only supports installing to / with no snapshots

mount -uw /

cp -R Build/SystemOverlay/System/Library/Extensions/ /System/Library/Extensions

chown -R root:wheel /System/Library/Extensions
chmod -R 755 /System/Library/Extensions

kmutil install --update-all --update-preboot

cp -R Build/SystemOverlay/ /

sync
reboot