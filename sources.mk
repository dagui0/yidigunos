GCC_VERSION	= 14.2.0
GLIBC_VERSION	= 2.40
GLIBC_MIN_KERNEL= 4.19

BINUTILS_SRC	= $(SRCDIR)/binutils-2.43.1
BINUTILS_DIST	= $(DISTDIR)/binutils-2.43.1.tar.xz
GCC_SRC		= $(SRCDIR)/gcc-$(GCC_VERSION)
GCC_DIST	= $(DISTDIR)/gcc-$(GCC_VERSION).tar.xz
GMP_SRC		= $(GCC_SRC)/gmp
GMP_DIST	= $(DISTDIR)/gmp-6.3.0.tar.xz
MPFR_SRC	= $(GCC_SRC)/mpfr
MPFR_DIST	= $(DISTDIR)/mpfr-4.2.1.tar.xz
MPC_SRC		= $(GCC_SRC)/mpc
MPC_DIST	= $(DISTDIR)/mpc-1.3.1.tar.gz
LINUX_SRC	= $(SRCDIR)/linux-6.10.5
LINUX_DIST	= $(DISTDIR)/linux-6.10.5.tar.xz
GLIBC_SRC	= $(SRCDIR)/glibc-$(GLIBC_VERSION)
GLIBC_DIST	= $(DISTDIR)/glibc-$(GLIBC_VERSION).tar.xz
M4_SRC		= $(SRCDIR)/m4-1.4.19
M4_DIST		= $(DISTDIR)/m4-1.4.19.tar.xz
NCURSES_SRC	= $(SRCDIR)/ncurses-6.5
NCURSES_DIST	= $(DISTDIR)/ncurses-6.5.tar.gz
BASH_SRC	= $(SRCDIR)/bash-5.2.32
BASH_DIST	= $(DISTDIR)/bash-5.2.32.tar.gz
COREUTILS_SRC	= $(SRCDIR)/coreutils-9.5
COREUTILS_DIST	= $(DISTDIR)/coreutils-9.5.tar.xz
DIFFUTILS_SRC	= $(SRCDIR)/diffutils-3.10
DIFFUTILS_DIST	= $(DISTDIR)/diffutils-3.10.tar.xz
FILE_SRC	= $(SRCDIR)/file-5.45
FILE_DIST	= $(DISTDIR)/file-5.45.tar.gz
FINDUTILS_SRC	= $(SRCDIR)/findutils-4.10.0
FINDUTILS_DIST	= $(DISTDIR)/findutils-4.10.0.tar.xz
GAWK_SRC	= $(SRCDIR)/gawk-5.3.0
GAWK_DIST	= $(DISTDIR)/gawk-5.3.0.tar.xz
GREP_SRC	= $(SRCDIR)/grep-3.11
GREP_DIST	= $(DISTDIR)/grep-3.11.tar.xz
GZIP_SRC	= $(SRCDIR)/gzip-1.13
GZIP_DIST	= $(DISTDIR)/gzip-1.13.tar.xz
MAKE_SRC	= $(SRCDIR)/make-4.4.1
MAKE_DIST	= $(DISTDIR)/make-4.4.1.tar.gz
PATCH_SRC	= $(SRCDIR)/patch-2.7.6
PATCH_DIST	= $(DISTDIR)/patch-2.7.6.tar.xz
SED_SRC		= $(SRCDIR)/sed-4.9
SED_DIST	= $(DISTDIR)/sed-4.9.tar.xz
TAR_SRC		= $(SRCDIR)/tar-1.35
TAR_DIST	= $(DISTDIR)/tar-1.35.tar.xz
XZ_SRC		= $(SRCDIR)/xz-5.6.2
XZ_DIST		= $(DISTDIR)/xz-5.6.2.tar.xz

GCC_PATCHES	= $(DISTDIR)/gcc-14.2.0-lfs_layout.patch
GLIBC_PATCHES	= $(DISTDIR)/glibc-$(GLIBC_VERSION)-fhs-1.patch
NCURSES_PATCHES	= $(DISTDIR)/ncurses-6.5-gawk.patch
COREUTILS_PATCHES= $(DISTDIR)/coreutils-9.5-i18n-2.patch

$(BINUTILS_SRC): $(BINUTILS_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(GCC_SRC): $(GCC_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		cd $@ && \
		for p in $(GCC_PATCHES); do \
			echo Applying patch $$p...; \
			patch -Np1 -i $$p || break; \
		done; \
	fi
$(GMP_SRC): $(GMP_DIST) $(GCC_SRC)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		mv `basename $< .tar.xz` $@; \
	fi
$(MPFR_SRC): $(MPFR_DIST) $(GCC_SRC)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		mv `basename $< .tar.xz` $@; \
	fi
$(MPC_SRC): $(MPC_DIST) $(GCC_SRC)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		mv `basename $< .tar.gz` $@; \
	fi
$(LINUX_SRC): $(LINUX_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(GLIBC_SRC): $(GLIBC_DIST) $(GLIBC_PATCHES)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $< && \
		cd $@ && \
		for p in $(GLIBC_PATCHES); do \
			echo Applying patch $$p...; \
			patch -Np1 -i $$p || break; \
		done; \
	fi
$(M4_SRC): $(M4_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(NCURSES_SRC): $(NCURSES_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		cd $@ && \
		for p in $(NCURSES_PATCHES); do \
			echo Applying patch $$p...; \
			patch -Np1 -i $$p || break; \
		done; \
	fi
$(BASH_SRC): $(BASH_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(COREUTILS_SRC): $(COREUTILS_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		cd $@ && \
		for p in $(COREUTILS_PATCHES); do \
			echo Applying patch $$p...; \
			patch -Np1 -i $$p || break; \
		done; \
	fi
$(DIFFUTILS_SRC): $(DIFFUTILS_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(FILE_SRC): $(FILE_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(FINDUTILS_SRC): $(FINDUTILS_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(GAWK_SRC): $(GAWK_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(GREP_SRC): $(GREP_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(GZIP_SRC): $(GZIP_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(MAKE_SRC): $(MAKE_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(PATCH_SRC): $(PATCH_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(SED_SRC): $(SED_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(TAR_SRC): $(TAR_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(XZ_SRC): $(XZ_DIST)
	@cd $(SRCDIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
