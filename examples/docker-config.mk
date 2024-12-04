LFS		= /mnt/lfs
LFS_DISPNM	= Yidigun OS
LFS_NAME	= yidigunos
LFS_TGT		= x86_64-$(LFS_NAME)-linux-gnu
TOOLS		= $(LFS)/tools

LFS_USER	= lfsuser
BUILD_DIR	= /home/$(LFS_USER)
PATCH_DIR	= $(BUILD_DIR)/patch
SRC_DIR		= $(BUILD_DIR)/src
DIST_DIR	= $(BUILD_DIR)/dist

# tools
READELF		= /usr/bin/readelf
