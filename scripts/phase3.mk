#
# Phase 3:
#  build all in chroot environment
#
include ../config.mk

.PHONY: phase3 clean extract

phase2:

clean:

include $(BUILD_DIR)/scripts/sources.mk
extract:

