# create folder where we place built frameworks
rm -r build

mkdir build

# build framework for simulators
xcodebuild clean build \
-project FanFindSDK.xcodeproj \
-scheme FanFindSDK \
-configuration Release \
-sdk iphonesimulator \
-derivedDataPath derived_data \
EXCLUDED_ARCHS="arm64"

# create folder to store compiled framework for simulator
mkdir build/simulator

# copy compiled framework for simulator into our build folder
cp -r derived_data/Build/Products/Release-iphonesimulator/FanFindSDK.framework build/simulator
#build framework for devices
xcodebuild clean build \
-project FanFindSDK.xcodeproj \
-scheme FanFindSDK \
-configuration Release \
-sdk iphoneos \
-derivedDataPath derived_data

# create folder to store compiled framework for simulator
mkdir build/devices
# copy compiled framework for simulator into our build folder
cp -r derived_data/Build/Products/Release-iphoneos/FanFindSDK.framework build/devices
# create folder to store compiled universal framework
mkdir build/universal
####################### Create universal framework #############################
# copy device framework into universal folder
cp -r build/devices/FanFindSDK.framework build/universal/
# create framework binary compatible with simulators and devices, and replace binary in unviersal framework
lipo -create \
build/simulator/FanFindSDK.framework/FanFindSDK \
build/devices/FanFindSDK.framework/FanFindSDK \
-output build/universal/FanFindSDK.framework/FanFindSDK

# copy simulator Swift public interface to universal framework
cp build/simulator/FanFindSDK.framework/Modules/FanFindSDK.swiftmodule/* build/universal/FanFindSDK.framework/Modules/FanFindSDK.swiftmodule
