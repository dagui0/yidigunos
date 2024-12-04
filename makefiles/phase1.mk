#
# Phase 1:
#  build cross-compiler
#
include ../config.mk

.PHONY: phase1 clean extract \
	binutils binutils-clean gcc gcc-clean linux-headers \
	glibc glibc-clean libstdc++ libstdc++-clean

phase1: binutils gcc linux-headers glibc libstdc++

clean: binutils-clean gcc-clean glibc-clean libstdc++-clean

include ../sources.mk
extract: $(BINUTILS_SRC) $(GCC_SRC) $(GMP_SRC) $(MPFR_SRC) $(MPC_SRC) \
	$(LINUX_SRC) $(GLIBC_SRC)

binutils: $(TOOLS)/bin/$(LFS_TGT)-ld
$(TOOLS)/bin/$(LFS_TGT)-ld: binutils-build/ld/ld-new
	cd binutils-build && \
	make install
binutils-build/ld/ld-new: binutils-build/Makefile
	cd binutils-build && \
	make -j`nproc`
binutils-build/Makefile: $(BINUTILS_SRC)
	mkdir -p binutils-build && \
	cd binutils-build && \
	$</configure \
	--prefix=$(TOOLS) \
	--with-sysroot=$(LFS) \
	--build=`$</config.guess` \
	--host=`$</config.guess` \
	--target=$(LFS_TGT) \
	--disable-nls \
	--enable-gprofng=no \
	--disable-werror \
	--enable-new-dtags \
	--enable-default-hash-style=gnu
binutils-clean:
	rm -rf binutils-build

gcc: binutils $(TOOLS)/bin/$(LFS_TGT)-gcc
$(TOOLS)/bin/$(LFS_TGT)-gcc: gcc-build/$(LFS_TGT)/libgcc/libgcc.a
	cd gcc-build && \
	make install && \
	(cd $(GCC_SRC) && \
	cat gcc/limitx.h gcc/glimits.h gcc/limity.h \
		>`dirname $$($(TOOLS)/bin/$(LFS_TGT)-gcc -print-libgcc-file-name)`/include/limits.h)
gcc-build/$(LFS_TGT)/libgcc/libgcc.a: gcc-build/Makefile
	cd gcc-build && \
	make -j`nproc`
gcc-build/Makefile: $(GCC_SRC) $(TOOLS)/bin/$(LFS_TGT)-ld $(GMP_SRC) $(MPFR_SRC) $(MPC_SRC)
	mkdir -p gcc-build && \
	cd gcc-build && \
	$</configure \
	--prefix=$(TOOLS) \
	--with-sysroot=$(LFS) \
	--host=`$</config.guess` \
	--build=`$</config.guess` \
	--target=$(LFS_TGT) \
	--with-glibc-version=$(GLIBC_VERSION) \
	--with-newlib \
	--without-headers \
	--enable-default-pie \
	--enable-default-ssp \
	--disable-nls \
	--disable-shared \
	--disable-multilib \
	--disable-threads \
	--disable-libatomic \
	--disable-libgomp \
	--disable-libquadmath \
	--disable-libssp \
	--disable-libvtv \
	--disable-libstdcxx \
	--enable-languages=c,c++
gcc-clean:
	rm -rf gcc-build

linux-headers: $(LFS)/usr/include/linux/types.h
$(LFS)/usr/include/linux/types.h: $(LINUX_SRC)
	cd $(LINUX_SRC) && \
	make -j`nproc` mrproper && \
	make -j`nproc` headers && \
	cp -r usr/include usr/include.tmp && \
	find usr/include.tmp -type f ! -name "*.h" -delete && \
	cp -rv usr/include.tmp $(LFS)/usr/include && \
	rm -rf usr/include.tmp

glibc: gcc linux-headers glibc-build/glibc-test.out
glibc-build/glibc-test.out: $(LFS)/usr/lib/libc.a $(LFS)/lib64/ld-linux-x86-64.so.2
	cd glibc-build && \
	echo 'int main(){}' | $(LFS_TGT)-gcc -xc - -o glibc-test.out && \
	$(READELF) -l glibc-test.out | grep ld-linux | \
		grep -q 'Requesting program interpreter: /lib64/ld-linux-x86-64.so.2' \
		|| { rm -f glibc-test.out; echo "glibc test failed" 1>&2; }
$(LFS)/usr/lib/libc.a: glibc-build/libc.a
	cd glibc-build && \
	make DESTDIR=$(LFS) install && \
	sed '/RTLDLIST=/s@/usr@@g' -i $(LFS)/usr/bin/ldd
glibc-build/libc.a: glibc-build/Makefile
	cd glibc-build && \
	make -j`nproc`
glibc-build/Makefile: $(GLIBC_SRC) glibc-build/configparms $(LFS)/usr/include/linux/types.h $(TOOLS)/bin/$(LFS_TGT)-gcc $(TOOLS)/bin/$(LFS_TGT)-ld
	mkdir -p glibc-build && \
	cd glibc-build && \
	$</configure \
	--prefix=/usr \
	--build=`$(GLIBC_SRC)/scripts/config.guess` \
	--host=$(LFS_TGT) \
	--enable-kernel=$(GLIBC_MIN_KERNEL) \
	--with-headers=$(LFS)/usr/include \
	--disable-nscd \
	libc_cv_slibdir=/usr/lib
glibc-build/configparms:
	mkdir -p glibc-build && \
	echo "rootsbindir=/usr/sbin" >glibc-build/configparms
glibc-clean:
	rm -rf glibc-build
$(LFS)/lib64/ld-linux-x86-64.so.2:
	case `uname -m` in \
	i?86) \
		ln -sfv ld-linux.so.2 \
			$(LFS)/lib/ld-lsb.so.3; \
		;; \
	x86_64) \
		ln -sfv ../lib/ld-linux-x86-64.so.2 \
			$(LFS)/lib64; \
		ln -sfv ../lib/ld-linux-x86-64.so.2 \
			$(LFS)/lib64/ld-lsb-x86-64.so.3; \
		;; \
	esac

libstdc++: glibc $(LFS)/usr/lib/libstdc++.a
$(LFS)/usr/lib/libstdc++.a: libstdc++-build/src/.libs/libstdc++.a
	cd libstdc++-build && \
	make DESTDIR=$(LFS) install && \
	rm -v $(LFS)/usr/lib/lib{stdc++{,exp,fs},supc++}.la
libstdc++-build/src/.libs/libstdc++.a: libstdc++-build/Makefile
	cd libstdc++-build && \
	make -j`nproc`
libstdc++-build/Makefile: $(GCC_SRC) $(LFS)/usr/lib/libc.a
	mkdir -p libstdc++-build && \
	cd libstdc++-build && \
	$</libstdc++-v3/configure \
	--build=`$</config.guess` \
	--host=$(LFS_TGT) \
	--prefix=/usr \
	--disable-multilib \
	--disable-nls \
	--disable-libstdcxx-pch \
	--with-gxx-include-dir=/tools/$(LFS_TGT)/include/c++/$(GCC_VERSION)
libstdc++-clean:
	rm -rf libstdc++-build
