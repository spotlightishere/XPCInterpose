# XPC Interpose

## Building
Building XPC Interpose requires [frida](https://github.com/frida/frida) - specifically via [swift-frida](https://github.com/spotlightishere/swift-frida). In order to accomplish such, the package downloads a prebuilt version (in XCFramework form) of the macOS x86_64 and arm64 devkits.

> **Note**
>
> Currently this is manually upgraded; to update the version of Frida downloaded, please submit an issue on the swift-frida repository. Upon Swift 5.9's release, build tool plugins should be sufficient to generate an XCFramework locally.
