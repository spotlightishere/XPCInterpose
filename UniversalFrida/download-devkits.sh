#!/bin/bash -e

#  download-devkits.sh
#  XPCInterpose
#
#  Created by Spotlight Deveaux on 2023-05-15.
#  

# All devkit filenames are provided by our output file list.
filelist_path=$SCRIPT_OUTPUT_FILE_LIST_0

# Loop through all lines/files in our output file list.
while read -r current_output_path; do
    # We expect current_output_path to contain an expanded form of something such as
    # $(DERIVED_FILE_DIR)/frida-core-devkit-$(FRIDA_VERSION)-macos-arm64.tar.xz.
    # Our resulting base name should be in the form of "frida-core-devkit-$(FRIDA_VERSION)-macos-arm64.tar.xz".
    devkit_filename=$(basename $current_output_path)

    # We have FRIDA_VERSION from this target's user-defined build setting.
    # Please update the version there instead of hardcoding here!
    frida_url="https://github.com/frida/frida/releases/download/${FRIDA_VERSION}/${devkit_filename}"
    curl $frida_url -o $current_output_path -L
done < $filelist_path

# Lastly, Xcode seems to want us to have output.
touch -d 1970-01-0100:00:00Z ${DERIVED_FILE_DIR}/frida_version
