#
# vars.mk
#

# -----------------------------------------------------------------------
# flags
#
MAKEFLAGS = -j1
MAKEFLAGS_PARALLEL = -j$(shell bash -c 'nproc')

# -----------------------------------------------------------------------
# triplets
#
CROSS_TARGET = arm-linux-gnueabihf
# In the process of building the cross-compilation toolchain a local toolchain is also created.
# To avoid confusion with any existing native compilation tools the "triplet" for this toolchain
# has the word "cross" embedded into it.
CROSS_HOST = $(shell bash -c 'echo $$MACHTYPE' | sed 's/-[^-]*/-cross/')

# -----------------------------------------------------------------------
#
# directories
#
CROSS_SYSROOT = $(shell pwd)/cross-sysroot
CROSS_TOOLS = $(shell pwd)/cross-tools
WORK = $(shell pwd)/work

# -----------------------------------------------------------------------
#
# versions
#
KERNEL_HEADERS_VERSION = 5.15.55
LIBGMP_VERSION = 6.3.0
LIBMPFR_VERSION = 4.2.1
LIBMPC_VERSION = 1.3.1
BINUTILS_VERSION = 2.39
GCC_VERSION = 12.4.0
GLIBC_VERSION = 2.36

# End of file
