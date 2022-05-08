Binpatcher $binaries/10.13.6*/GeForceTesla.kext/Contents/MacOS/GeForceTesla Build/GeForceTesla.patched '
# IOFree panic je --> jmp
set 0x5cf9a
write 0xeb'

Binpatcher $binaries/10.13.6*/NVDAResmanTesla.kext/Contents/MacOS/NVDAResmanTesla Build/NVDAResmanTesla.patched '
# like NDRVShim but worse
set 0x1ea598
write 0xeb
set 0x0
forward 0x56534c47657374616c74
write 0x494f4c6f636b4c6f636b'

Binpatcher $binaries/10.15.7*/IOSurface.kext/Contents/MacOS/IOSurface Build/IOSurface.patched '
# addMemoryRegion/removeMemoryRegion names panic
set 0xdb52
write 0xeb
set 0xdbc6
write 0xeb'