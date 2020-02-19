#
# vars.mk
#

HOST = $(shell echo $$MACHTYPE | sed "s/$$(echo $$MACHTYPE | cut -d- -f2)/cross/")
TARGET = arm-crux-linux-gnueabihf

TOPDIR  = $(shell pwd)
CLFS = $(TOPDIR)/clfs
CROSSTOOLS = $(TOPDIR)/crosstools
WORK = $(TOPDIR)/work

KERNEL_HEADERS_VERSION = 4.19.24
LIBGMP_VERSION = 6.1.2
LIBMPFR_VERSION = 4.0.1
LIBMPC_VERSION = 1.1.0
BINUTILS_VERSION = 2.32
GCC_VERSION = 8.3.0
GLIBC_VERSION = 2.28

ABI = aapcs-linux
MODE = arm
FLOAT = hard

# Make jobs
MJ=-j2

# End of file
