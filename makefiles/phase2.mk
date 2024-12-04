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

include ../sources.mk
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

ncurses: $(LFS)/usr/lib/libcurses.a
$(LFS)/usr/lib/libcurses.a: ncurses-build/ncurses
	cd ncurses-build && \
	make DESTDIR=$(LFS) TIC_PATH=`pwd`/build/progs/tic install && \
	ln -sv libncursesw.so $(LFS)/usr/lib/libncurses.so && \
	sed -e 's/^#if.*XOPEN.*$/#if 1/' \
		-i $(LFS)/usr/include/curses.h
ncurses-build/ncurses: ncurses-build/Makefile
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
	make -j`nproc` include && \
	make -j`nproc` progs tic
ncurses-tic/Makefile: $(NCURSES_SRC)
	mkdir -p ncurses-tic && \
	cd ncurses-tic && \
	$</configure
ncurses-clean:
	rm -rf ncurses-build
