---
layout: post
title: How to create an Xcode alternative toolchain to load a custom Clang plugin
date: 2022-05-30 15:09 -0700
---
# What is an alternative toolchain?

An alternative toolchain is a way to package up a compiler, linker, headers, settings, etc. into a single directory. If this directory is placed under one of the following special directories:

- `~/Library/Developer/Toolchains`
- `/Library/Developer/Toolchains`

(Note that these directories are not part of the standard distribution and will need to be created)

then it will appear in Xcode:

<img src="/assets/images/xcode-dev-clang-toolchain-menu-background.jpg" alt="Using the Xcode Toolchain menu to switch to my custom dev toolchain." width="516" height="377" srcset="/assets/images/xcode-dev-clang-toolchain-menu-background.jpg 1x, /assets/images/xcode-dev-clang-toolchain-menu-background@2x.jpg 2x">

# Why use an alternative toolchain?

If you would like a convenient way in Xcode to switch between the standard toolchain and a custom Clang build with a <a href="https://clang.llvm.org/docs/ClangPlugins.html" target="_blank" rel="noreferrer noopener">custom plugin</a>.

# How do you create one?

1. Build LLVM as an Xcode toolchain and symlink it into one of the special directories (e.g. `~/Library/Developer/Toolchains`).
   
   Here's how I checked out and built LLVM after installing <a href="https://cmake.org/download/" target="_blank" rel="noreferrer noopener">CMake</a> and <a href="https://github.com/ninja-build/ninja/releases" target="_blank" rel="noreferrer noopener">Ninja</a>:
   
   ```bash
   % cd ~/Source 
   % git clone https://github.com/llvm/llvm-project.git
   % cd llvm-project
   % ./lldb/scripts/macos-setup-codesign.sh
   % CC=clang CXX=clang++ \
   cmake -S llvm -B "Build" -G Ninja \
       -DCMAKE_INSTALL_PREFIX="$HOME/LLVMInstall" \
       -DLLVM_CREATE_XCODE_TOOLCHAIN="On" \
       -DCMAKE_BUILD_TYPE="Release" \
       -DLLDB_EXPORT_ALL_SYMBOLS="1" \
       -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
       -DLLVM_TARGETS_TO_BUILD="X86" \
       -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;compiler-rt;flang;libclc;lld;lldb;openmp;polly'
   ```
   This checks out LLVM into `~/Source/llvm-project` and builds LLVM, Clang, lldb and few other projects. The built products will be placed in `~/Source/llvm-project/Build` and then installed under `~/LLVMInstall`.


2. Amend the built toolchain's `Info.plist` to add a `OverrideBuildSettings`[^1] dictionary that tells Xcode to load your custom plugin + some fixups: 

   ```xml
   <plist version="1.0">
   <dict>
       ...
       <key>OverrideBuildSettings</key>
       <dict>
           <key>CLANG_TOOLCHAIN_FLAGS</key>
           <string>-Xclang -load -Xclang /path/to/custom/plugin.dylib -Xclang -add-plugin -Xclang PluginNameAsEncodedInPluginDylib</string>
           <key>COMPILER_INDEX_STORE_ENABLE</key>
           <string>NO</string>
           <key>OTHER_CPLUSPLUSFLAGS</key>
           <string>$(inherit) -isystem $(SDKROOT)/usr/include/c++/v1</string>
       </dict>
   </dict>
   </plist>
   
   ```

3. Done.

The fixups: setting `COMPILER_INDEX_STORE_ENABLE` to `NO` and amending `OTHER_CPLUSPLUSFLAGS` to adding `$(SDKROOT)/usr/include/c++/v1` to the system header search path are needed to avoid build failures. The latter is needed when using the toolchain to compile C++ code due to the fact that an alternative toolchain doesn't include the same set of C++ headers as those included in the official Apple SDK and thus you would see errors like:

```bash
fatal error: 'vector' file not found
```

The former is needed because Xcode would otherwise try to invoke clang with a command line option that isn't compiled in with a default LLVM build to tell it to build an index and you would see this error:

```bash
clang-14: error: unknown argument: '-index-store-path'
clang-14: error: cannot specify -o when generating multiple output files
```

# Footnotes

[^1]: Mentioned in <a href="https://github.com/apple/swift/blob/main/utils/build-script-impl" target="_blank" rel="noreferrer noopener">https://github.com/apple/swift/blob/main/utils/build-script-impl</a>
