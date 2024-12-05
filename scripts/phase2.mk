#
# Phase 2:
#  build cross-toolchain
#
include ../config.mk

.PHONY: phase2 clean extract \
	m4 m4-clean ncurses ncurses-clean bash bash-clean \
	coreutils coreutils-clean diffutils diffutils-clean \
	file file-clean findutils findutils-clean gawk gawk-clean \
	grep grep-clean gzip gzip-clean make make-clean \
	patch patch-clean sed sed-clean tar tar-clean xz xz-clean \
	binutils binutils-clean gcc gcc-clean

phase2: m4 ncurses bash coreutils diffutils file findutils gawk \
	grep gzip make patch sed tar xz binutils gcc

clean: m4-clean ncurses-clean bash-clean coreutils-clean diffutils-clean \
	file-clean findutils-clean gawk-clean grep-clean gzip-clean \
	make-clean patch-clean sed-clean tar-clean xz-clean \
	binutils-clean gcc gcc-clean

include $(BUILD_DIR)/scripts/sources.mk
extract: $(M4_SRC) $(NCURSES_SRC) $(BASH_SRC) $(COREUTILS_SRC) \
	$(DIFFUTILS_SRC) $(FILE_SRC) $(FINDUTILS_SRC) $(GAWK_SRC) \
	$(GREP_SRC) $(GZIP_SRC) $(MAKE_SRC) $(PATCH_SRC) $(SED_SRC) \
	$(TAR_SRC) $(XZ_SRC) \
	$(BINUTILS_SRC) $(GCC_SRC) $(GMP_SRC) $(MPFR_SRC) $(MPC_SRC)

m4: $(LFS)/usr/bin/m4
$(LFS)/usr/bin/m4: m4-build/m4
	cd m4-build && \
	make DESTDIR=$(LFS) install
m4-build/m4: m4-build/Makefile
	cd m4-build && \
	make -j`nproc`
m4-build/Makefile: $(M4_SRC)
	mkdir -p m4-build && \
	cd m4-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</build-aux/config.guess`
m4-clean:
	rm -rf m4-build

ncurses: $(LFS)/usr/lib/libncursesw.so.6.5
$(LFS)/usr/lib/libncursesw.so.6.5: ncurses-build/lib/libncursesw.so.6.5 ncurses-tic/progs/tic
	cd ncurses-build && \
	make DESTDIR=$(LFS) TIC_PATH=`pwd`/../ncurses-tic/progs/tic install && \
	ln -sfv libncursesw.so $(LFS)/usr/lib/libncurses.so
ncurses-build/lib/libncursesw.so.6.5: ncurses-build/Makefile
	cd ncurses-build && \
	make -j`nproc`
ncurses-build/Makefile: $(NCURSES_SRC)
	mkdir -p ncurses-build && \
	cd ncurses-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</config.guess` \
	--mandir=/usr/share/man \
	--with-man-pages-format=normal \
	--with-shared \
	--without-normal \
	--with-cxx-shared \
	--without-debug \
	--without-ada \
	--disable-stripping
ncurses-tic/progs/tic: ncurses-tic/Makefile
	cd ncurses-tic && \
	make -j`nproc` -C include && \
	make -j`nproc` -C progs tic
ncurses-tic/Makefile: $(NCURSES_SRC)
	mkdir -p ncurses-tic && \
	cd ncurses-tic && \
	$</configure
ncurses-clean:
	rm -rf ncurses-build ncurses-tic

bash: $(LFS)/usr/bin/bash
$(LFS)/usr/bin/bash: bash-build/bash
	cd bash-build && \
	make DESTDIR=$(LFS) install && \
	ln -sfv bash $(LFS)/usr/bin/sh
bash-build/bash: bash-build/Makefile
	cd bash-build && \
	make -j`nproc`
bash-build/Makefile: $(BASH_SRC)
	mkdir -p bash-build && \
	cd bash-build && \
	$</configure \
	--prefix=/usr \
	--build=`sh $</support/config.guess` \
	--host=$(LFS_TGT) \
	--without-bash-malloc \
	bash_cv_strtold_broken=no
bash-clean:
	rm -rf bash-build

coreutils: $(LFS)/usr/sbin/chroot
$(LFS)/usr/sbin/chroot: coreutils-build/src/chroot
	cd coreutils-build && \
	make DESTDIR=$(LFS) install && \
	mv -v $(LFS)/usr/bin/chroot $(LFS)/usr/sbin && \
	mkdir -pv $(LFS)/usr/share/man/man8 && \
	mv -v $(LFS)/usr/share/man/man1/chroot.1 $(LFS)/usr/share/man/man8/chroot.8 && \
	sed -i 's/"1"/"8"/' $(LFS)/usr/share/man/man8/chroot.8
coreutils-build/src/chroot: coreutils-build/Makefile
	cd coreutils-build && \
	make -j`nproc`
coreutils-build/Makefile: $(COREUTILS_SRC)
	mkdir -p coreutils-build && \
	cd coreutils-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</build-aux/config.guess` \
	--enable-install-program=hostname \
	--enable-no-install-program=kill,uptime
coreutils-clean:
	rm -rf coreutils-build

diffutils: $(LFS)/usr/bin/diff
$(LFS)/usr/bin/diff: diffutils-build/src/diff
	cd diffutils-build && \
	make DESTDIR=$(LFS) install
diffutils-build/src/diff: diffutils-build/Makefile
	cd diffutils-build && \
	make -j`nproc`
diffutils-build/Makefile: $(DIFFUTILS_SRC)
	mkdir -p diffutils-build && \
	cd diffutils-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</build-aux/config.guess`
diffutils-clean:
	rm -rf diffutils-build

file: $(LFS)/usr/bin/file
$(LFS)/usr/bin/file: file-build/src/file
	cd file-build && \
	make DESTDIR=$(LFS) install && \
	rm -vf $(LFS)/usr/lib/libmagic.la
file-build/src/file: file-build/Makefile file-host-build/src/file
	cd file-build && \
	make -j`nproc` FILE_COMPILE=`pwd`/../file-host-build/src/file
file-build/Makefile: $(FILE_SRC)
	mkdir -p file-build && \
	cd file-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</config.guess`
file-host-build/src/file: file-host-build/Makefile
	cd file-host-build && \
	make -j`nproc`
file-host-build/Makefile: $(FILE_SRC)
	mkdir -p file-host-build && \
	cd file-host-build && \
	$</configure \
	--disable-bzlib \
	--disable-libseccomp \
	--disable-xzlib \
	--disable-zlib
file-clean:
	rm -rf file-build file-host-build

findutils: $(LFS)/usr/bin/find
$(LFS)/usr/bin/find: findutils-build/find/find
	cd findutils-build && \
	make DESTDIR=$(LFS) install
findutils-build/find/find: findutils-build/Makefile
	cd findutils-build && \
	make -j`nproc`
findutils-build/Makefile: $(FINDUTILS_SRC)
	mkdir -p findutils-build && \
	cd findutils-build && \
	$</configure \
	--prefix=/usr \
	--localstatedir=/var/lib/locate \
	--host=$(LFS_TGT)                 \
	--build=`$</build-aux/config.guess`
findutils-clean:
	rm -rf findutils-build

gawk: $(LFS)/usr/bin/gawk
$(LFS)/usr/bin/gawk: gawk-build/gawk
	cd gawk-build && \
	make DESTDIR=$(LFS) install
gawk-build/gawk: gawk-build/Makefile
	cd gawk-build && \
	make -j`nproc` DIST_SUBDIRS="support . extension doc awklib po test"
gawk-build/Makefile: $(GAWK_SRC)
	mkdir -p gawk-build && \
	cd gawk-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</build-aux/config.guess`
gawk-clean:
	rm -rf gawk-build

grep: $(LFS)/usr/bin/grep
$(LFS)/usr/bin/grep: grep-build/src/grep
	cd grep-build && \
	make DESTDIR=$(LFS) install
grep-build/src/grep: grep-build/Makefile
	cd grep-build && \
	make -j`nproc`
grep-build/Makefile: $(GREP_SRC)
	mkdir -p grep-build && \
	cd grep-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</build-aux/config.guess`
grep-clean:
	rm -rf grep-build

gzip: $(LFS)/usr/bin/gzip
$(LFS)/usr/bin/gzip: gzip-build/gzip
	cd gzip-build && \
	make DESTDIR=$(LFS) install
gzip-build/gzip: gzip-build/Makefile
	cd gzip-build && \
	make -j`nproc`
gzip-build/Makefile: $(GZIP_SRC)
	mkdir -p gzip-build && \
	cd gzip-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT)
gzip-clean:
	rm -rf gzip-build

make: $(LFS)/usr/bin/make
$(LFS)/usr/bin/make: make-build/make
	cd make-build && \
	make DESTDIR=$(LFS) install
make-build/make: make-build/Makefile
	cd make-build && \
	make -j`nproc`
make-build/Makefile: $(MAKE_SRC)
	mkdir -p make-build && \
	cd make-build && \
	$</configure \
	--prefix=/usr \
	--without-guile \
	--host=$(LFS_TGT) \
	--build=`$</build-aux/config.guess`
make-clean:
	rm -rf make-build

patch: $(LFS)/usr/bin/patch
$(LFS)/usr/bin/patch: patch-build/src/patch
	cd patch-build && \
	make DESTDIR=$(LFS) install
patch-build/src/patch: patch-build/Makefile
	cd patch-build && \
	make -j`nproc`
patch-build/Makefile: $(PATCH_SRC)
	mkdir -p patch-build && \
	cd patch-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</build-aux/config.guess`
patch-clean:
	rm -rf patch-build

sed: $(LFS)/usr/bin/sed
$(LFS)/usr/bin/sed: sed-build/sed/sed
	cd sed-build && \
	make DESTDIR=$(LFS) install
sed-build/sed/sed: sed-build/Makefile
	cd sed-build && \
	make -j`nproc`
sed-build/Makefile: $(SED_SRC)
	mkdir -p sed-build && \
	cd sed-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</build-aux/config.guess`
sed-clean:
	rm -rf sed-build

tar: $(LFS)/usr/bin/tar
$(LFS)/usr/bin/tar: tar-build/src/tar
	cd tar-build && \
	make DESTDIR=$(LFS) install
tar-build/src/tar: tar-build/Makefile
	cd tar-build && \
	make -j`nproc`
tar-build/Makefile: $(TAR_SRC)
	mkdir -p tar-build && \
	cd tar-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</build-aux/config.guess`
tar-clean:
	rm -rf tar-build

xz: $(LFS)/usr/bin/xz
$(LFS)/usr/bin/xz: xz-build/src/xz
	cd xz-build && \
	make DESTDIR=$(LFS) install && \
	rm -vf $(LFS)/usr/lib/liblzma.la
xz-build/src/xz: xz-build/Makefile
	cd xz-build && \
	make -j`nproc`
xz-build/Makefile: $(XZ_SRC)
	mkdir -p xz-build && \
	cd xz-build && \
	$</configure \
	--prefix=/usr \
	--host=$(LFS_TGT) \
	--build=`$</build-aux/config.guess` \
	--disable-static \
	--docdir=/usr/share/doc/xz-5.6.2	
xz-clean:
	rm -rf xz-build

binutils: $(LFS)/usr/bin/ld
$(LFS)/usr/bin/ld: binutils-build/ld/ld-new
	cd binutils-build && \
	make DESTDIR=$(LFS) install && \
	rm -vf $(LFS)/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
binutils-build/ld/ld-new: binutils-build/Makefile
	cd binutils-build && \
	make -j`nproc`
binutils-build/Makefile: $(BINUTILS_SRC) $(BINUTILS_SRC)/toolchain-patched
	mkdir -p binutils-build && \
	cd binutils-build && \
	$</configure \
	--prefix=/usr \
	--build=`$</config.guess` \
	--host=$(LFS_TGT) \
	--disable-nls \
	--enable-shared \
	--enable-gprofng=no \
	--disable-werror \
	--enable-64-bit-bfd \
	--enable-new-dtags \
	--enable-default-hash-style=gnu
binutils-clean:
	rm -rf binutils-build

gcc: $(LFS)/usr/bin/gcc
$(LFS)/usr/bin/gcc: gcc-build/$(LFS_TGT)/libgcc/libgcc.a
	cd gcc-build && \
	make DESTDIR=$(LFS) install && \
	ln -svf gcc $(LFS)/usr/bin/cc
gcc-build/$(LFS_TGT)/libgcc/libgcc.a: gcc-build/Makefile
	cd gcc-build && \
	make -j`nproc`
gcc-build/Makefile: $(GCC_SRC) $(GMP_SRC) $(MPFR_SRC) $(MPC_SRC)
	mkdir -p gcc-build && \
	cd gcc-build && \
	$</configure \
	--host=$(LFS_TGT) \
	--build=`$</config.guess` \
	--target=$(LFS_TGT) \
	LDFLAGS_FOR_TARGET=-L`pwd`/$(LFS_TGT)/libgcc \
	--prefix=/usr \
	--with-build-sysroot=$(LFS) \
	--enable-default-pie \
	--enable-default-ssp \
	--disable-nls \
	--disable-multilib \
	--disable-libatomic \
	--disable-libgomp \
	--disable-libquadmath \
	--disable-libsanitizer \
	--disable-libssp \
	--disable-libvtv \
	--enable-languages=c,c++
gcc-clean:
	rm -rf gcc-build
