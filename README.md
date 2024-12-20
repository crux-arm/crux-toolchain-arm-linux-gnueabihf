# crux-toolchain-arm-linux-gnueabihf

Build releases can be downloaded from here:
https://sourceforge.net/projects/crux-arm/files/toolchain/


## Setting Up the Toolchain

1. Extract the tarball to `/opt/arm-linux-gnueabihf`:

   ```bash
   sudo tar -xzvf crux-toolchain-arm-linux-gnueabihf.VERSION.tar.gz -C /opt/arm-linux-gnueabihf
   ```

2. Add the `bin` directory to `PATH`:

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

6. Using the Toolchain

   Now your ARM toolchain should be set up correctly, and you can use it to
   cross-compile for ARM architectures. For example, to compile a C program, run:
   ```bash
   arm-linux-gnueabihf-gcc -o my_program my_program.c
   ```
