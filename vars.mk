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
LIBGMP_VERSION = 6.0.0a
LIBMPFR_VERSION = 3.1.2
LIBMPC_VERSION = 1.0.2
BINUTILS_VERSION = 2.24
GCC_VERSION = 4.8.3
GLIBC_VERSION = 2.19

ABI = aapcs-linux
MODE = arm
FLOAT = hard

# End of file
