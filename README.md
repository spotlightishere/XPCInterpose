# XPC Interpose

## Building
Building XPC Interpose requires [frida](https://github.com/frida/frida) - specifically, [frida-swift](https://github.com/frida/frida-swift). In order to accomplish such, downloading a prebuilt version of the macOS x86_64 and arm64 devkits are integrated as a target dependency within the Xcode project.

> **Note**
>
> To upgrade the version of Frida downloaded, modify the `FRIDA_VERSION` file within `UniversalFrida.xcconfig` in the UniversalFrida directory. Please additionally upgrade the frida-swift submodule if necessary.
