#!/bin/bash -e

#  build-universal-frida.sh
#  XPCInterpose
#
#  Created by Spotlight Deveaux on 2023-05-15.
#

# Our input file - $(SRCROOT)/UniversalFrida/frida-swift - is our
# base framework source code. We'll make a copy of it per architecture.
original_frida_swift=$SCRIPT_INPUT_FILE_0

# Let's create an array of architectures based off $ARCHS_STANDARD.
# We'll use this to iterate through all possible devkits.
DEVKIT_ARCHS=($ARCHS_STANDARD)

# We don't use the devkit filenames are provided by our output file list:
# instead, we assume that every architecture under $ARCHS_STANDARD has a devkit.
# (Please modify the list to match such, should it not!)
# We specify it to ensure frameworks are rebuilt if the devkit file list changes.
for current_arch in ${DEVKIT_ARCHS[@]}; do
    # Previously, we assumed $(DERIVED_FILE_DIR)/frida-core-devkit-$(FRIDA_VERSION)-macos-$(ARCH).tar.xz.
    # We'll assume the same here.
    devkit_path="${DERIVED_FILE_DIR}/frida-core-devkit-${FRIDA_VERSION}-macos-${current_arch}.tar.xz"
    
    # We'll make a copy of the frida-swift source for this architecture.
    frida_swift_path="${DERIVED_FILE_DIR}/frida-swift-${current_arch}"
    cp -r $original_frida_swift $frida_swift_path
    # Next, extract the devkit to the CFrida dir.
    tar -xvf $devkit_path -C $frida_swift_path/CFrida
    # Lastly, build!
    cd $frida_swift_path
    # TODO: SWIFT_INSTALL_OBJC_HEADER is a hack to avoid https://github.com/apple/swift/issues/64669
    xcodebuild DISABLE_MANUAL_TARGET_ORDER_BUILD_WARNING=YES OTHER_SWIFT_FLAGS=-no-verify-emitted-module-interface -arch $current_arch -configuration $CONFIGURATION
done

######################
# Framework creation #
######################
# Helper function to get architecture-specific framework path
frida_framework_path() {
    echo "${DERIVED_FILE_DIR}/frida-swift-$1/build/${CONFIGURATION}/Frida.framework"
}

# Now that we've built every architecture's framework, we'll create our own.
archs_count=${#DEVKIT_ARCHS[@]}

# We'll use the first architecture as a basis for the framework.
product_framework_path="${BUILD_DIR}/${CONFIGURATION}/Frida.framework"
first_arch=${DEVKIT_ARCHS[0]}

# Copy the first architecture over as our emitted product.
cp -a $(frida_framework_path $first_arch)/* $product_framework_path

# For all remaining frameworks, copy Swift module information, and use lipo to merge the framework binary.
for ((i=1; i < archs_count; i++)); do
    current_arch=${DEVKIT_ARCHS[i]}
    current_framework_path=$(frida_framework_path $current_arch)
    # Merge Swift module information.
    cp -r $current_framework_path/Versions/A/Modules/Frida.swiftmodule/* $product_framework_path/Versions/A/Modules/Frida.swiftmodule
    # Lipo the two together.
    lipo $product_framework_path/Versions/A/Frida $current_framework_path/Versions/A/Frida -output $product_framework_path/Versions/A/Frida -create
done

# Mark that we've built.
touch -d 1970-01-0100:00:00Z ${DERIVED_FILE_DIR}/merged_framework
