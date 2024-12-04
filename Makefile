include config.mk
.PHONY: reset-lfs init-lfs download \
	phase1 phase1-clean \
	phase2 phase2-clean \
	phase3 phase3-clean \
	dist-download dist-checksum \
	src-extract src-clean

usage:
	@echo; \
	echo "***** LFS Makefile for $(LFS_DISPNM) *****"; \
	echo; \
	echo "usage:"; \
	echo "   make { init-lfs | reset-lfs | dist-download | dist-checksum" ; \
	echo "          | phase1 | phase1-clean | phase2 | phase2-clean"; \
	echo "          | phase3 | phase3-clean }"; \
	echo; \
	echo "configs:"; \
	echo " - LFS        = $(LFS)"; \
	echo " - LFS_DISPNM = $(LFS_DISPNM)"; \
	echo " - LFS_NAME   = $(LFS_NAME)"; \
	echo " - LFS_TGT    = $(LFS_TGT)"; \
	echo

download: dist-download dist-checksum

dist-download:
	mkdir -p $(DIST_DIR) && \
	wget --input-file=$(BUILD_DIR)/bin/wget-list-sysv --continue \
		--directory-prefix=$(DIST_DIR)

dist-checksum:
	cd $(DIST_DIR) && \
	md5sum -c $(BUILD_DIR)/bin/md5sums

src-clean:
	rm -rf $(SRC_DIR)/*

phase1:
	mkdir -p phase1 && \
	$(MAKE) -j`nproc` -C phase1 -f $(BUILD_DIR)/phase1.mk phase1

phase1-clean:
	mkdir -p phase1 && \
	$(MAKE) -j`nproc` -C phase1 -f $(BUILD_DIR)/phase1.mk clean

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
