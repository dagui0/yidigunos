GCC_VERSION		= 14.2.0
GLIBC_VERSION		= 2.40
GLIBC_MIN_KERNEL	= 4.19

COREUTILS_PATCHES	= $(DIST_DIR)/coreutils-9.5-i18n-2.patch
GCC_PATCHES		= $(PATCH_DIR)/gcc-14.2.0-lfs_layout.patch
GLIBC_PATCHES		= $(DIST_DIR)/glibc-$(GLIBC_VERSION)-fhs-1.patch
NCURSES_PATCHES		= $(PATCH_DIR)/ncurses-6.5-gawk.patch

BINUTILS_SRC		= $(SRC_DIR)/binutils-2.43.1
BINUTILS_DIST		= $(DIST_DIR)/binutils-2.43.1.tar.xz
GCC_SRC			= $(SRC_DIR)/gcc-$(GCC_VERSION)
GCC_DIST		= $(DIST_DIR)/gcc-$(GCC_VERSION).tar.xz
GMP_SRC			= $(GCC_SRC)/gmp
GMP_DIST		= $(DIST_DIR)/gmp-6.3.0.tar.xz
MPFR_SRC		= $(GCC_SRC)/mpfr
MPFR_DIST		= $(DIST_DIR)/mpfr-4.2.1.tar.xz
MPC_SRC			= $(GCC_SRC)/mpc
MPC_DIST		= $(DIST_DIR)/mpc-1.3.1.tar.gz
LINUX_SRC		= $(SRC_DIR)/linux-6.10.5
LINUX_DIST		= $(DIST_DIR)/linux-6.10.5.tar.xz
GLIBC_SRC		= $(SRC_DIR)/glibc-$(GLIBC_VERSION)
GLIBC_DIST		= $(DIST_DIR)/glibc-$(GLIBC_VERSION).tar.xz
M4_SRC			= $(SRC_DIR)/m4-1.4.19
M4_DIST			= $(DIST_DIR)/m4-1.4.19.tar.xz
NCURSES_SRC		= $(SRC_DIR)/ncurses-6.5
NCURSES_DIST		= $(DIST_DIR)/ncurses-6.5.tar.gz
BASH_SRC		= $(SRC_DIR)/bash-5.2.32
BASH_DIST		= $(DIST_DIR)/bash-5.2.32.tar.gz
COREUTILS_SRC		= $(SRC_DIR)/coreutils-9.5
COREUTILS_DIST		= $(DIST_DIR)/coreutils-9.5.tar.xz
DIFFUTILS_SRC		= $(SRC_DIR)/diffutils-3.10
DIFFUTILS_DIST		= $(DIST_DIR)/diffutils-3.10.tar.xz
FILE_SRC		= $(SRC_DIR)/file-5.45
FILE_DIST		= $(DIST_DIR)/file-5.45.tar.gz
FINDUTILS_SRC		= $(SRC_DIR)/findutils-4.10.0
FINDUTILS_DIST		= $(DIST_DIR)/findutils-4.10.0.tar.xz
GAWK_SRC		= $(SRC_DIR)/gawk-5.3.0
GAWK_DIST		= $(DIST_DIR)/gawk-5.3.0.tar.xz
GREP_SRC		= $(SRC_DIR)/grep-3.11
GREP_DIST		= $(DIST_DIR)/grep-3.11.tar.xz
GZIP_SRC		= $(SRC_DIR)/gzip-1.13
GZIP_DIST		= $(DIST_DIR)/gzip-1.13.tar.xz
MAKE_SRC		= $(SRC_DIR)/make-4.4.1
MAKE_DIST		= $(DIST_DIR)/make-4.4.1.tar.gz
PATCH_SRC		= $(SRC_DIR)/patch-2.7.6
PATCH_DIST		= $(DIST_DIR)/patch-2.7.6.tar.xz
SED_SRC			= $(SRC_DIR)/sed-4.9
SED_DIST		= $(DIST_DIR)/sed-4.9.tar.xz
TAR_SRC			= $(SRC_DIR)/tar-1.35
TAR_DIST		= $(DIST_DIR)/tar-1.35.tar.xz
XZ_SRC			= $(SRC_DIR)/xz-5.6.2
XZ_DIST			= $(DIST_DIR)/xz-5.6.2.tar.xz

$(DIST_DIR):
	mkdir -p $@
$(SRC_DIR):
	mkdir -p $@

$(BINUTILS_SRC): $(BINUTILS_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(GCC_SRC): $(GCC_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		cd $@ && \
		for p in $(GCC_PATCHES); do \
			echo Applying patch $$p...; \
			patch -Np1 -i $$p || break; \
		done; \
	fi
$(GMP_SRC): $(GMP_DIST) $(GCC_SRC) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		mv `basename $< .tar.xz` $@; \
	fi
$(MPFR_SRC): $(MPFR_DIST) $(GCC_SRC) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		mv `basename $< .tar.xz` $@; \
	fi
$(MPC_SRC): $(MPC_DIST) $(GCC_SRC) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		mv `basename $< .tar.gz` $@; \
	fi
$(LINUX_SRC): $(LINUX_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(GLIBC_SRC): $(GLIBC_DIST) $(GLIBC_PATCHES) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $< && \
		cd $@ && \
		for p in $(GLIBC_PATCHES); do \
			echo Applying patch $$p...; \
			patch -Np1 -i $$p || break; \
		done; \
	fi
$(M4_SRC): $(M4_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(NCURSES_SRC): $(NCURSES_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		cd $@ && \
		for p in $(NCURSES_PATCHES); do \
			echo Applying patch $$p...; \
			patch -Np1 -i $$p || break; \
		done; \
	fi
$(BASH_SRC): $(BASH_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(COREUTILS_SRC): $(COREUTILS_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
		cd $@ && \
		for p in $(COREUTILS_PATCHES); do \
			echo Applying patch $$p...; \
			patch -Np1 -i $$p || break; \
		done; \
	fi
$(DIFFUTILS_SRC): $(DIFFUTILS_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(FILE_SRC): $(FILE_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(FINDUTILS_SRC): $(FINDUTILS_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(GAWK_SRC): $(GAWK_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(GREP_SRC): $(GREP_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(GZIP_SRC): $(GZIP_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(MAKE_SRC): $(MAKE_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(PATCH_SRC): $(PATCH_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(SED_SRC): $(SED_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(TAR_SRC): $(TAR_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
$(XZ_SRC): $(XZ_DIST) $(SRC_DIR)
	@mkdir -p $(SRC_DIR) && \
	cd $(SRC_DIR); \
	if [ ! -d $@ ]; then \
		echo Extracting `basename $<` ...; \
		tar xf $<; \
	fi
