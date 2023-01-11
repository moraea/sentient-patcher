overlay=Build/SystemOverlay
rm -rf $overlay

sle=$overlay/System/Library/Extensions
slpf=$overlay/System/Library/PrivateFrameworks
slf=$overlay/System/Library/Frameworks
mkdir -p $sle
mkdir -p $slpf
mkdir -p $slf

cp -R $binaries/10.14.3*/OpenGL.framework $slf
rm -f $slf/OpenGL.framework/Versions/A/Libraries/libCoreFSCache.dylib

cp -R $binaries/10.14.3*/GPUSupport.framework $slpf

wrapped=Build/non-metal-frameworks/Build/13

mkdir -p $slpf/SkyLight.framework/Versions/A
cp $wrapped/Common/SkyLight $wrapped/Common/SkyLightOld.dylib $slpf/SkyLight.framework/Versions/A
ln -s A $slpf/SkyLight.framework/Versions/Current
ln -s Versions/Current/SkyLight $slpf/SkyLight.framework/SkyLight

mkdir -p $slf/CoreDisplay.framework/Versions/A
cp $wrapped/Common/CoreDisplay $wrapped/Common/CoreDisplayOld.dylib $slf/CoreDisplay.framework/Versions/A
ln -s A $slf/CoreDisplay.framework/Versions/Current
ln -s Versions/Current/CoreDisplay $slf/CoreDisplay.framework/CoreDisplay

if test -e $wrapped/Common/QuartzCore
then
	mkdir -p $slf/QuartzCore.framework/Versions/A
	cp $wrapped/Common/QuartzCore $wrapped/Common/QuartzCoreOld.dylib $slf/QuartzCore.framework/Versions/A
	ln -s A $slf/QuartzCore.framework/Versions/Current
	ln -s Versions/Current/QuartzCore $slf/QuartzCore.framework/QuartzCore
fi

mkdir -p $slf/IOSurface.framework/Versions/A
cp $wrapped/Zoe/IOSurface $wrapped/Zoe/IOSurfaceOld.dylib $slf/IOSurface.framework/Versions/A
ln -s A $slf/IOSurface.framework/Versions/Current
ln -s Versions/Current/IOSurface $slf/IOSurface.framework/IOSurface

cp -R $binaries/10.13.6*/GeForceTesla.kext $sle
cp Build/GeForceTesla.patched $sle/GeForceTesla.kext/Contents/MacOS/GeForceTesla

cp -R $binaries/10.13.6*/NVDAResmanTesla.kext $sle
cp Build/NVDAResmanTesla.patched $sle/NVDAResmanTesla.kext/Contents/MacOS/NVDAResmanTesla

cp -R $binaries/10.13.6*/NVDANV50HalTesla.kext $sle

cp -R $binaries/10.13.6*/GeForceTeslaGLDriver.bundle $sle

cp -R $binaries/10.15.7*/IOSurface.kext $sle
cp Build/IOSurface.patched $sle/IOSurface.kext/Contents/MacOS/IOSurface

cp -R $binaries/10.15.7*/NVDAStartup.kext $sle