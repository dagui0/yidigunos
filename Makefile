include config.mk
.PHONY: version-check init-lfs reset-lfs \
	dist-download dist-checksum src-clean \
	phase1 phase1-clean \
	phase2 phase2-clean \
	phase3 phase3-clean

usage:
	@echo; \
	echo "***** LFS Makefile for $(LFS_DISPNM) *****"; \
	echo; \
	echo "usage:"; \
	echo "   make { version-check | init-lfs | reset-lfs" ; \
	echo "          | dist-download | dist-checksum | src-clean"; \
	echo "          | phase1 | phase1-clean | phase2 | phase2-clean"; \
	echo "          | phase3 | phase3-clean }"; \
	echo; \
	echo "configs:"; \
	echo " - LFS        = $(LFS)"; \
	echo " - LFS_DISPNM = $(LFS_DISPNM)"; \
	echo " - LFS_NAME   = $(LFS_NAME)"; \
	echo " - LFS_TGT    = $(LFS_TGT)"; \
	echo " - BUILD_DIR  = $(BUILD_DIR)"; \
	echo " - SRC_DIR    = $(SRC_DIR)"; \
	echo " - DIST_DIR   = $(DIST_DIR)"; \
	echo

download: dist-download dist-checksum

DIST_LIST	= https://www.linuxfromscratch.org/lfs/view/12.2/wget-list-sysv
DIST_MD5SUM	= https://www.linuxfromscratch.org/lfs/view/12.2/md5sums

dist-download:
	mkdir -p $(DIST_DIR) && \
	cd $(DIST_DIR) && \
	wget $(DIST_LIST) && \
	wget --input-file=$(DIST_DIR)/wget-list-sysv --continue \
		--directory-prefix=$(DIST_DIR)

dist-checksum:
	mkdir -p $(DIST_DIR) && \
	cd $(DIST_DIR) && \
	wget $(DIST_MD5SUM) && \
	md5sum -c $(DIST_DIR)/md5sums

src-clean:
	rm -rf $(SRC_DIR)/*

PHASE1_COMPLETE	= $(TOOLS)/bin/$(LFS_TGT)-ld $(TOOLS)/bin/$(LFS_TGT)-gcc \
	$(LFS)/usr/include/linux/types.h $(LFS)/usr/lib/libc.a $(LFS)/usr/lib/libstdc++.a
PHASE2_COMPLETE	= $(LFS)/usr/bin/m4 $(LFS)/usr/lib/libncursesw.so.6.5 \
	$(LFS)/usr/bin/bash $(LFS)/usr/sbin/chroot $(LFS)/usr/bin/diff \
	$(LFS)/usr/bin/file $(LFS)/usr/bin/find $(LFS)/usr/bin/gawk \
	$(LFS)/usr/bin/grep $(LFS)/usr/bin/gzip $(LFS)/usr/bin/make \
	$(LFS)/usr/bin/patch $(LFS)/usr/bin/sed $(LFS)/usr/bin/tar \
	$(LFS)/usr/bin/xz $(LFS)/usr/bin/ld $(LFS)/usr/bin/gcc

phase1:
	mkdir -p phase1 && \
	$(MAKE) -j`nproc` -C phase1 -f $(BUILD_DIR)/scripts/phase1.mk phase1

phase1-clean:
	mkdir -p phase1 && \
	$(MAKE) -j`nproc` -C phase1 -f $(BUILD_DIR)/scripts/phase1.mk clean

phase2: $(PHASE1_COMPLETE)
	mkdir -p phase2 && \
	$(MAKE) -j`nproc` -C phase2 -f $(BUILD_DIR)/scripts/phase2.mk phase2

phase2-clean:
	mkdir -p phase2 && \
	$(MAKE) -j`nproc` -C phase2 -f $(BUILD_DIR)/scripts/phase2.mk clean

version-check:
	$(BUILD_DIR)/scripts/version-check.sh

init-lfs:
	mkdir -p $(LFS) $(LFS)/tools \
		$(LFS)/etc $(LFS)/lib64 \
		$(LFS)/usr/bin $(LFS)/usr/lib $(LFS)/usr/sbin \
		$(LFS)/tmp $(LFS)/var && \
	chmod 01777 $(LFS)/tmp && \
	ln -s usr/bin $(LFS)/bin && \
	ln -s usr/sbin $(LFS)/sbin && \
	ln -s usr/lib $(LFS)/lib

reset-lfs:
	rm -rf $(LFS)/tools/* \
		$(LFS)/etc/* \
		$(LFS)/lib64/* \
		$(LFS)/usr/bin/* \
		$(LFS)/usr/lib/* \
		$(LFS)/usr/sbin/* \
		$(LFS)/usr/include \
		$(LFS)/usr/libexec \
		$(LFS)/usr/share \
		$(LFS)/var/*
