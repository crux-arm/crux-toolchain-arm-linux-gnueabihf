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
LIBGMP_VERSION = 5.1.2
LIBMPFR_VERSION = 3.1.2
LIBMPC_VERSION = 1.0.1
BINUTILS_VERSION = 2.23.1
GCC_VERSION = 4.7.3
GLIBC_VERSION = 2.16.0
LIBTOOL_VERSION = 2.4.2

ABI = aapcs-linux
MODE = arm
FLOAT = hard

# End of file
