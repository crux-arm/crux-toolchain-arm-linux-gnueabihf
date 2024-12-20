# -----------------------------------------------------------------------
#
# Makefile
#


CURL_CMD = curl -sSL --retry 5 --retry-max-time 60

ifneq ("$(wildcard vars.mk)", "")
include vars.mk
endif

all: linux-headers libgmp libmpfr libmpc binutils gcc-static  glibc gcc-final test

.PHONY: clean
clean: \
	linux-headers-clean \
	libgmp-clean \
	libmpfr-clean \
	libmpc-clean \
	binutils-clean \
	gcc-static-clean \
	glibc-clean \
	gcc-final-clean \
	test-clean

.PHONY: distclean
distclean: \
	clean \
	linux-headers-distclean \
	libgmp-distclean \
	libmpfr-distclean \
	libmpc-distclean \
	binutils-distclean \
	gcc-static-distclean \
	glibc-distclean \
	gcc-final-distclean \
	test-distclean

.PHONY: download
download: \
	$(WORK)/linux-$(KERNEL_HEADERS_VERSION).tar.xz \
	$(WORK)/gmp-$(LIBGMP_VERSION).tar.xz \
	$(WORK)/mpfr-$(LIBMPFR_VERSION).tar.xz \
	$(WORK)/mpc-$(LIBMPC_VERSION).tar.gz \
	$(WORK)/binutils-$(BINUTILS_VERSION).tar.bz2 \
	$(WORK)/gcc-$(GCC_VERSION).tar.xz \
	$(WORK)/glibc-$(GLIBC_VERSION).tar.bz2 \

# -----------------------------------------------------------------------
#
# linux-headers
#

$(WORK)/linux-$(KERNEL_HEADERS_VERSION).tar.xz:
	$(CURL_CMD) -o $(WORK)/linux-$(KERNEL_HEADERS_VERSION).tar.xz \
		https://www.kernel.org/pub/linux/kernel/v5.x/linux-$(KERNEL_HEADERS_VERSION).tar.xz

$(WORK)/linux-$(KERNEL_HEADERS_VERSION): $(WORK)/linux-$(KERNEL_HEADERS_VERSION).tar.xz
	tar -C $(WORK) -xf $(WORK)/linux-$(KERNEL_HEADERS_VERSION).tar.xz
	touch $(WORK)/linux-$(KERNEL_HEADERS_VERSION)

$(CROSS_SYSROOT)/usr/include/asm: $(WORK)/linux-$(KERNEL_HEADERS_VERSION)
	@echo "[`date +'%F %T'`] Building linux-headers"
	mkdir -p $(CROSS_SYSROOT)/usr/include
	cd $(WORK)/linux-$(KERNEL_HEADERS_VERSION) && \
		make mrproper && \
		make ARCH=arm INSTALL_HDR_PATH=$(CROSS_SYSROOT)/usr headers_install
	touch $(CROSS_SYSROOT)/usr/include/asm

.PHONY: linux-headers
linux-headers: $(CROSS_SYSROOT)/usr/include/asm

.PHONY: linux-headers-clean
linux-headers-clean:
	rm -rf $(WORK)/linux-$(KERNEL_HEADERS_VERSION)

.PHONY: linux-headers-distclean
linux-headers-distclean: linux-headers-clean
	rm -f $(WORK)/linux-$(KERNEL_HEADERS_VERSION).tar.xz

# -----------------------------------------------------------------------
#
# libgmp
#

$(WORK)/gmp-$(LIBGMP_VERSION).tar.xz:
	$(CURL_CMD) -o $(WORK)/gmp-$(LIBGMP_VERSION).tar.xz \
		https://ftp.gnu.org/gnu/gmp/gmp-$(LIBGMP_VERSION).tar.xz

$(WORK)/gmp-$(LIBGMP_VERSION): $(WORK)/gmp-$(LIBGMP_VERSION).tar.xz
	tar -C $(WORK) -xvf $(WORK)/gmp-$(LIBGMP_VERSION).tar.xz
	touch $(WORK)/gmp-$(LIBGMP_VERSION)

$(WORK)/build-libgmp: $(WORK)/gmp-$(LIBGMP_VERSION)
	mkdir -p $(WORK)/build-libgmp
	touch $(WORK)/build-libgmp

$(CROSS_TOOLS)/lib/libgmp.so: $(WORK)/build-libgmp
	@echo "[`date +'%F %T'`] Building libgmp"
	cd $(WORK)/build-libgmp && \
		unset CFLAGS && \
		unset CXXFLAGS && \
		CPPFLAGS=-fexceptions \
		$(WORK)/gmp-$(LIBGMP_VERSION)/configure \
			--build=$(CROSS_HOST) \
			--prefix=$(CROSS_TOOLS) \
			--enable-cxx && \
		make $(MAKEFLAGS_PARALLEL) && \
		make install && \
		rm -rf $(CROSS_TOOLS)/share
	touch $(CROSS_TOOLS)/lib/libgmp.so

.PHONY: libgmp
libgmp: $(CROSS_TOOLS)/lib/libgmp.so

.PHONY: libgmp-clean
libgmp-clean:
	rm -rf $(WORK)/build-libgmp $(WORK)/gmp-$(LIBGMP_VERSION)

.PHONY: libgmp-distclean
libgmp-distclean: libgmp-clean
	rm -rf $(WORK)/gmp-$(LIBGMP_VERSION).tar.xz

# -----------------------------------------------------------------------
#
# libmpfr
#

$(WORK)/mpfr-$(LIBMPFR_VERSION).tar.xz:
	$(CURL_CMD) -o $(WORK)/mpfr-$(LIBMPFR_VERSION).tar.xz \
		https://ftp.gnu.org/gnu/mpfr/mpfr-$(LIBMPFR_VERSION).tar.xz

$(WORK)/mpfr-$(LIBMPFR_VERSION): $(WORK)/mpfr-$(LIBMPFR_VERSION).tar.xz
	tar -C $(WORK) -xvf $(WORK)/mpfr-$(LIBMPFR_VERSION).tar.xz
	touch $(WORK)/mpfr-$(LIBMPFR_VERSION)

$(WORK)/build-libmpfr: $(WORK)/mpfr-$(LIBMPFR_VERSION)
	mkdir -p $(WORK)/build-libmpfr
	touch $(WORK)/build-libmpfr

$(CROSS_TOOLS)/lib/libmpfr.so: $(WORK)/build-libmpfr
	@echo "[`date +'%F %T'`] Building libmpfr"
	cd $(WORK)/build-libmpfr && \
		unset CFLAGS && \
		unset CXXFLAGS && \
		LDFLAGS="-Wl,-rpath,$(CROSS_TOOLS)/lib" && \
		$(WORK)/mpfr-$(LIBMPFR_VERSION)/configure \
			--prefix=$(CROSS_TOOLS) \
			--enable-shared \
			--with-gmp=$(CROSS_TOOLS) && \
		make ${MAKEFLAGS_PARALLEL} && \
		make install && \
		rm -rf $(CROSS_TOOLS)/share
	touch $(CROSS_TOOLS)/lib/libmpfr.so

.PHONY: libmpfr
libmpfr: libgmp $(CROSS_TOOLS)/lib/libmpfr.so

.PHONY: libmpfr-clean
libmpfr-clean:
	rm -vrf $(WORK)/build-libmpfr $(WORK)/mpfr-$(LIBMPFR_VERSION)

.PHONY: libmpfr-distclean
libmpfr-distclean: libmpfr-clean
	rm -vrf $(WORK)/mpfr-$(LIBMPFR_VERSION).tar.xz

# -----------------------------------------------------------------------
#
# libmpc
#

$(WORK)/mpc-$(LIBMPC_VERSION).tar.gz:
	$(CURL_CMD) -o $(WORK)/mpc-$(LIBMPC_VERSION).tar.gz \
		https://ftp.gnu.org/gnu/mpc/mpc-$(LIBMPC_VERSION).tar.gz

$(WORK)/mpc-$(LIBMPC_VERSION): $(WORK)/mpc-$(LIBMPC_VERSION).tar.gz
	tar -C $(WORK) -xvf $(WORK)/mpc-$(LIBMPC_VERSION).tar.gz
	touch $(WORK)/mpc-$(LIBMPC_VERSION)

$(WORK)/build-libmpc: $(WORK)/mpc-$(LIBMPC_VERSION)
	mkdir -p $(WORK)/build-libmpc
	touch $(WORK)/build-libmpc

$(CROSS_TOOLS)/lib/libmpc.so: $(WORK)/build-libmpc
	@echo "[`date +'%F %T'`] Building libmpc"
	cd $(WORK)/build-libmpc && \
		unset CFLAGS && \
		unset CXXFLAGS && \
		LDFLAGS="-Wl,-rpath,$(CROSS_TOOLS)/lib" && \
		$(WORK)/mpc-$(LIBMPC_VERSION)/configure \
			--prefix=$(CROSS_TOOLS) \
			--with-gmp=$(CROSS_TOOLS) \
			--with-mpfr=$(CROSS_TOOLS) && \
		make ${MAKEFLAGS_PARALLEL} && \
		make install
	touch $(CROSS_TOOLS)/lib/libmpc.so

.PHONY: libmpc
libmpc: libmpfr $(CROSS_TOOLS)/lib/libmpc.so

.PHONY: libmpc-clean
libmpc-clean:
	rm -vrf $(WORK)/build-libmpc $(WORK)/mpc-$(LIBMPC_VERSION)

.PHONY: libmpc-distclean
libmpc-distclean: libmpc-clean
	rm -vrf $(WORK)/mpc-$(LIBMPC_VERSION).tar.gz

# -----------------------------------------------------------------------
#
# binutils
#

$(WORK)/binutils-$(BINUTILS_VERSION).tar.bz2:
	$(CURL_CMD) -o $(WORK)/binutils-$(BINUTILS_VERSION).tar.bz2 \
		https://ftp.gnu.org/gnu/binutils/binutils-$(BINUTILS_VERSION).tar.bz2

$(WORK)/binutils-$(BINUTILS_VERSION): $(WORK)/binutils-$(BINUTILS_VERSION).tar.bz2
	tar -C $(WORK) -xf $(WORK)/binutils-$(BINUTILS_VERSION).tar.bz2
	sed -i '/^SUBDIRS/s/doc//' $(WORK)/binutils-$(BINUTILS_VERSION)/*/Makefile.in
	touch $(WORK)/binutils-$(BINUTILS_VERSION)

$(WORK)/build-binutils: $(WORK)/binutils-$(BINUTILS_VERSION)
	mkdir -p $(WORK)/build-binutils
	touch $(WORK)/build-binutils

$(CROSS_SYSROOT)/usr/include/libiberty.h: $(WORK)/build-binutils
	@echo "[`date +'%F %T'`] Building binutils"
	cd $(WORK)/build-binutils && \
		unset CFLAGS && \
		unset CXXFLAGS && \
		AR=ar \
		AS=as \
		$(WORK)/binutils-$(BINUTILS_VERSION)/configure \
			--target=$(CROSS_TARGET) \
			--prefix=$(CROSS_TOOLS) \
			--with-sysroot=$(CROSS_SYSROOT) \
			--enable-shared \
			--enable-ld=default \
			--enable-gold=yes \
			--disable-nls \
			--disable-multilib && \
		sed -e '/^MAKEINFO/s:=.*:= true:' -i Makefile && \
		make ${MAKEFLAGS_PARALLEL} && \
		make install && \
		rm -rf $(CROSS_TOOLS)/share
	cp -va $(WORK)/binutils-$(BINUTILS_VERSION)/include/libiberty.h $(CROSS_SYSROOT)/usr/include
	touch $(CROSS_SYSROOT)/usr/include/libiberty.h

.PHONY: binutils
binutils: linux-headers $(CROSS_SYSROOT)/usr/include/libiberty.h

.PHONY: binutils-clean
binutils-clean:
	rm -rf $(WORK)/build-binutils $(WORK)/binutils-$(BINUTILS_VERSION)

.PHONY: binutils-distclean
binutils-distclean: binutils-clean
	rm -f $(WORK)/binutils-$(BINUTILS_VERSION).tar.bz2

# -----------------------------------------------------------------------
#
# gcc-static
#

$(WORK)/gcc-$(GCC_VERSION).tar.xz:
	$(CURL_CMD) -o $(WORK)/gcc-$(GCC_VERSION).tar.xz \
		https://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VERSION)/gcc-$(GCC_VERSION).tar.xz

$(WORK)/gcc-$(GCC_VERSION): $(WORK)/gcc-$(GCC_VERSION).tar.xz
	tar -C $(WORK) -xvf $(WORK)/gcc-$(GCC_VERSION).tar.xz
	touch $(WORK)/gcc-$(GCC_VERSION)

$(WORK)/build-gcc-static: $(WORK)/gcc-$(GCC_VERSION)
	mkdir -p $(WORK)/build-gcc-static
	touch $(WORK)/build-gcc-static

$(CROSS_TOOLS)/lib/gcc: $(WORK)/build-gcc-static $(WORK)/gcc-$(GCC_VERSION)
	@echo "[`date +'%F %T'`] Building gcc-static"
	cd $(WORK)/build-gcc-static && \
		unset CFLAGS && \
		unset CXXFLAGS && \
		AR=ar \
		LDFLAGS="-Wl,-rpath,$(CROSS_TOOLS)/lib" \
		$(WORK)/gcc-$(GCC_VERSION)/configure \
			--build=$(CROSS_HOST) \
			--host=$(CROSS_HOST) \
			--target=$(CROSS_TARGET) \
			--prefix=$(CROSS_TOOLS) \
			--libexecdir=$(CROSS_TOOLS)/lib \
			--with-pkgversion="CRUX-ARM (armhf)" \
			--with-sysroot=$(CROSS_SYSROOT) \
			--with-gmp=$(CROSS_TOOLS) \
			--with-mpfr=$(CROSS_TOOLS) \
			--with-mpc=$(CROSS_TOOLS) \
			--with-abi=aapcs-linux \
			--with-mode=arm \
			--with-float=hard \
			--with-newlib \
			--without-headers	\
			--disable-decimal-float \
			--disable-libgomp \
			--disable-libmudflap \
			--disable-libssp \
			--disable-multilib \
			--disable-nls \
			--disable-shared \
			--disable-threads \
			--enable-languages=c \
			--enable-__cxa_atexit \
			--enable-symvers=gnu && \
		make $(MAKEFLAGS_PARALLEL) all-gcc all-target-libgcc && \
		make install-gcc install-target-libgcc
	touch $(CROSS_TOOLS)/lib/gcc

.PHONY: gcc-static
gcc-static: linux-headers libgmp libmpfr libmpc binutils $(CROSS_TOOLS)/lib/gcc

.PHONY: gcc-static-clean
gcc-static-clean:
	rm -vrf $(WORK)/build-gcc-static $(WORK)/gcc-$(GCC_VERSION)

.PHONY: gcc-static-distclean
gcc-static-distclean: gcc-static-clean
	rm -vf $(WORK)/gcc-$(GCC_VERSION).tar.xz

# -----------------------------------------------------------------------
#
# glibc
#

$(WORK)/glibc-$(GLIBC_VERSION).tar.bz2:
	$(CURL_CMD) -o $(WORK)/glibc-$(GLIBC_VERSION).tar.bz2  \
		https://ftp.gnu.org/gnu/glibc/glibc-$(GLIBC_VERSION).tar.bz2

$(WORK)/glibc-$(GLIBC_VERSION): $(WORK)/glibc-$(GLIBC_VERSION).tar.bz2
	tar -C $(WORK) -xvjf $(WORK)/glibc-$(GLIBC_VERSION).tar.bz2
	touch $(WORK)/glibc-$(GLIBC_VERSION)

$(WORK)/build-glibc: $(WORK)/glibc-$(GLIBC_VERSION)
	mkdir -p $(WORK)/build-glibc
	touch $(WORK)/build-glibc
	
$(CROSS_SYSROOT)/usr/lib/libc.so: $(WORK)/build-glibc $(WORK)/glibc-$(GLIBC_VERSION)
	@echo "[`date +'%F %T'`] Building glibc"
	cd $(WORK)/build-glibc && \
		export PATH=$(CROSS_TOOLS)/bin:$$PATH && \
		echo "libc_cv_forced_unwind=yes" > config.cache && \
		echo "install_root=$(CROSS_SYSROOT)" > configparms && \
		unset CFLAGS && \
		unset CXXFLAGS && \
		BUILD_CC="gcc" \
		CC="$(CROSS_TARGET)-gcc" \
		CXX="$(CROSS_TARGET)-gcc" \
		AR="$(CROSS_TARGET)-ar" \
		RANLIB="$(CROSS_TARGET)-ranlib" \
		$(WORK)/glibc-$(GLIBC_VERSION)/configure 	\
			--host=$(CROSS_TARGET) \
			--build=$(CROSS_HOST) \
			--prefix=/usr \
			--disable-profile \
			--enable-add-ons \
			--enable-kernel=2.6.32 \
			--enable-obsolete-rpc \
			--with-__thread \
			--with-tls \
			--with-fp=yes \
			--with-binutils=$(CROSS_TOOLS)/bin \
			--with-headers=$(CROSS_SYSROOT)/usr/include \
			--cache-file=config.cache && \
		make ${MAKEFLAGS_PARALLEL} && \
		make install
	touch $(CROSS_SYSROOT)/usr/lib/libc.so

.PHONY: glibc
glibc: linux-headers binutils gcc-static $(CROSS_SYSROOT)/usr/lib/libc.so

.PHONY: glibc-clean
glibc-clean:
	rm -rf $(WORK)/build-glibc $(WORK)/glibc-$(GLIBC_VERSION)

.PHONY: glibc-distclean
glibc-distclean: glibc-clean
	rm -f $(WORK)/glibc-$(GLIBC_VERSION).tar.bz2 $(WORK)/glibc-ports-$(GLIBC_VERSION).tar.bz2

# -----------------------------------------------------------------------
#
# gcc-final
#

$(WORK)/build-gcc-final: $(WORK)/gcc-$(GCC_VERSION)
	mkdir -p $(WORK)/build-gcc-final
	touch $(WORK)/build-gcc-final

$(CROSS_SYSROOT)/lib/gcc: $(WORK)/build-gcc-final $(WORK)/gcc-$(GCC_VERSION)
	@echo "[`date +'%F %T'`] Building gcc-final"
	cd $(WORK)/build-gcc-final && \
		export PATH=$(CROSS_TOOLS)/bin:$$PATH && \
		unset CC && \
		unset CFLAGS && \
		unset CXXFLAGS && \
		AR=ar \
		LDFLAGS="-Wl,-rpath,$(CROSS_TOOLS)/lib" \
		$(WORK)/gcc-$(GCC_VERSION)/configure \
			--build=$(CROSS_HOST) \
			--host=$(CROSS_HOST) \
			--target=$(CROSS_TARGET) \
			--prefix=$(CROSS_TOOLS) \
			--libexecdir=$(CROSS_TOOLS)/lib \
			--with-pkgversion="CRUX-ARM (armhf)" \
			--with-sysroot=$(CROSS_SYSROOT) \
			--with-gmp=$(CROSS_TOOLS) \
			--with-mpfr=$(CROSS_TOOLS) \
			--with-mpc=$(CROSS_TOOLS) \
			--with-abi=aapcs-linux \
			--with-mode=arm \
			--with-float=hard \
			--without-headers \
			--disable-multilib \
			--disable-nls \
			--disable-libgomp \
			--disable-libmudflap \
			--disable-libssp \
			--disable-bootstrap \
			--disable-libstdcxx-pch \
			--enable-__cxa_atexit \
			--enable-languages=c,c++ \
			--enable-shared  \
			--enable-threads=posix && \
		make $(MAKEFLAGS_PARALLEL) AS_FOR_CROSS_TARGET="$(CROSS_TARGET)-as" LD_FOR_CROSS_TARGET="$(CROSS_TARGET)-ld" && \
		make install || exit 1
	cp -va $(WORK)/build-gcc-final/$(CROSS_TARGET)/libstdc++-v3/src/.libs/libstdc++.so* $(CROSS_SYSROOT)/usr/lib
	cp -va $(WORK)/build-gcc-final/$(CROSS_TARGET)/libgcc/libgcc_s.so* $(CROSS_SYSROOT)/usr/lib
	touch $(CROSS_SYSROOT)/lib/gcc

.PHONY: gcc-final
gcc-final: libgmp libmpfr glibc $(CROSS_SYSROOT)/lib/gcc

.PHONY: gcc-final-clean
gcc-final-clean:
	rm -rf $(WORK)/build-gcc-final $(WORK)/gcc-$(GCC_VERSION)

.PHONY: gcc-final-distclean
gcc-final-distclean: gcc-final-clean
	rm -f $(WORK)/gcc-$(GCC_VERSION).tar.xz

# -----------------------------------------------------------------------
#
# test
#

$(WORK)/test: $(WORK)/test.c
	@echo "[`date +'%F %T'`] Testing toolchain"
	export PATH=$(CROSS_TOOLS)/bin:$$PATH && \
	unset CFLAGS && \
	unset CXXFLAGS && \
	unset CC && \
	AR=ar \
	LDFLAGS="-Wl,-rpath,$(CROSS_TOOLS)/lib" \
	$(CROSS_TARGET)-gcc -O2 -pipe -Wall -o $(WORK)/test $(WORK)/test.c
	[ "`file -b $(WORK)/test | cut -d',' -f2 | sed 's| ||g'`" = "ARM"  ] || exit 1
	touch $(WORK)/test

.PHONY: test
test: gcc-final $(WORK)/test

.PHONY: test-clean
test-clean:
	rm -vrf $(WORK)/test

.PHONY: test-distclean
test-distclean: test-clean

# End of file
