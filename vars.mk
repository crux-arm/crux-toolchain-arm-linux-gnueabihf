#
# vars.mk
#

HOST = $(shell echo $$MACHTYPE | sed "s/$$(echo $$MACHTYPE | cut -d- -f2)/cross/")
TARGET = arm-crux-linux-gnueabihf

PWD  = $(shell pwd)
CLFS = $(PWD)/clfs
CROSSTOOLS = $(PWD)/crosstools
WORK = $(PWD)/work

KERNEL_HEADERS_VERSION = 2.6.35.6
LIBGMP_VERSION = 5.0.2
LIBMPFR_VERSION = 3.1.0
LIBMPC_VERSION = 0.9
BINUTILS_VERSION = 2.21.1
GCC_VERSION = 4.6.1
GLIBC_VERSION = 2.13

# Hardfp EfikaMX imx51
ABI = aapcs-linux
ARCH = armv7-a
FPU = vfpv3-d16
MODE = thumb
FLOAT = hard

# End of file
