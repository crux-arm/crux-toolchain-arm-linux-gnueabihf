#
# vars.mk
#

HOST = $(shell echo $$MACHTYPE | sed "s/$$(echo $$MACHTYPE | cut -d- -f2)/cross/")
TARGET = arm-crux-linux-gnueabihf

TOPDIR  = $(shell pwd)
CLFS = $(TOPDIR)/clfs
CROSSTOOLS = $(TOPDIR)/crosstools
WORK = $(TOPDIR)/work

KERNEL_HEADERS_VERSION = 3.5.4
LIBGMP_VERSION = 5.0.5
LIBMPFR_VERSION = 3.1.1
LIBMPC_VERSION = 1.0.1
BINUTILS_VERSION = 2.22
GCC_VERSION = 4.7.2
GLIBC_VERSION = 2.16.0

ABI = aapcs-linux
MODE = arm
FLOAT = hard

# End of file
