include config.mk
.PHONY: reset-lfs init-lfs download checksum \
	phase1 phase1-clean \
	phase2 phase2-clean \
	phase3 phase3-clean \
	src-clean

usage:
	@echo "usage: make { phase1 | phase2 | phase3 | reset-lfs }"

download:
	cd $(DISTDIR) && \
	wget --input-file=$(DISTDIR)/wget-list-sysv --continue \
		--directory-prefix=$(DISTDIR)

checksum:
	cd $(DISTDIR) && \
	md5sum -c $(DISTDIR)/md5sums

phase1:
	make -j`nproc` -C phase1

phase1-clean:
	make -j`nproc` -C phase1 clean

phase2:
	#make -j`nproc` -C phase3

phase2-clean:
	#make -j`nproc` -C phase2 clean

phase3:
	#make -j`nproc` -C phase3

phase3-clean:
	#make -j`nproc` -C phase3 clean

src-clean:
	rm -rf $(SRCDIR)/*

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
