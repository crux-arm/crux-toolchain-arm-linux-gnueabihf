# crux-toolchain-arm-linux-gnueabihf

`arm-linux-gnueabihf` is a cross-compilation toolchain designed for targeting ARM processors running Linux, specifically for systems that support hardware floating-point operations (hard-float).
It includes tools like the GCC compiler (GNU Compiler Collection) and other utilities for building software that can run on an ARM-based Linux system with hard-float support.

## Download the Toolchain

Toolchain releases can be downloaded from here:
https://sourceforge.net/projects/crux-arm/files/toolchain/


## Setting Up the Toolchain

1. Install to `/opt/arm-linux-gnueabihf`

   Once you have download the toolchain (e.g: crux-toolchain-arm-linux-gnueabihf-VERSION.tar.gz) you need to extract it to `/`.

   ```bash
   sudo tar -xzvf crux-toolchain-arm-linux-gnueabihf-VERSION.tar.gz -C /
   ```

   > When you extract the tarball to `/`, it will install it to `/opt/arm-linux-gnueabihf` due to the prefix in the tarball contents.
   > The internal `opt/arm-linux-gnueabihf/` directory structure in the tarball is likely there for a reason. Many software packages, especially cross-compilation tools or embedded system libraries, follow this structure to:
   > - Ensure correct installation: These tools expect to be located in specific directories.
   > - Avoid conflicts with system directories: By placing the tools in a custom directory.



3. Add the `bin` directory to `PATH`:

   After extracting the toolchain, you need to add the bin directory where cross-tools
   of the toolchain are located to your PATH so you can use the ARM tools from anywhere.
   ```bash
   export PATH=$PATH:/opt/arm-linux-gnueabihf/cross-tools/bin
   ```

4. Set cross-compilation variables:

   If you're cross-compiling, you may want to set some environment variables for convenience:
   ```bash
   export CROSS_COMPILE=arm-linux-gnueabihf-
   export ARCH=arm
   ```
   - `CROSS_COMPILE` is used by many build systems to specify the cross-compilation toolchain prefix.
   - `ARCH` is used to set this to specify the architecture you're targeting.

5. Verify the toolchain:

   To confirm that the toolchain is installed and accessible, try checking the
   version of the ARM GCC compiler:
   ```bash
   arm-linux-gnueabihf-gcc --version
   ```
   If the setup is successful, you should see the version of arm-linux-gnueabihf-gcc.
   You can also verify other tools like the assembler (as) or linker (ld):

   ```bash
   arm-linux-gnueabihf-as --version
   arm-linux-gnueabihf-ld --version
   ```

## Using the Toolchain

   Now your ARM toolchain should be set up correctly, and you can use it to
   cross-compile for ARM architectures. For example, to compile a C program, run:
   ```bash
   arm-linux-gnueabihf-gcc -o my_program my_program.c
   ```
