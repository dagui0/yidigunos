# Yidigun OS

## 개요

이대규가 혼자 개발하는 OS이다.

### 기반 OS

[Linux from Scratch](https://www.linuxfromscratch.org/)에 기반한다.

#### 참고자료

* Linux from Scratch 12.2: https://www.linuxfromscratch.org/lfs/view/12.2/
* Linux From Scratch 9.1 (한국어판): https://rawcdn.githack.com/NuttyJamie/LinuxFromScratch-for-Korean/88bdabae8abf2fad511b497b0dc676e6ac95b965/9.1/BOOK/HTML/index.html
* Mac LFS: https://github.com/chaimleib/maclfs
* Cross-Compiled Linux From Scratch - Embedded: https://clfs.org/view/clfs-embedded/x86/

### 목표 시스템

* 시스템 아키텍처: x86_64
* 하드웨어: VMware 가상머신
  * RAM: 2 GiB
  * HDD #0: 30 GiB (target system)
* 사용 목적: 개발 공부 및 테스트

### 호스트 시스템

* OS: Slax 12.2.0 ISO (debian)
* installed via apt
  * binutils
  * bison
  * gawk
  * gcc
  * g++
  * m4
  * make
  * patch
  * texinfo
  * vim

```sh
sudo apt update && \
sudo apt -y install binutils bison gawk gcc g++ git gparted m4 make patch texinfo vim wget && \
sudo apt clean all
```

coreutils
  automake required
  help2man required

### Build Phase 1

```sh
#!/bin/bash -v

cd $LFS/sources/phase1

(cd binutils && \
../../binutils-2.43.1/configure \
--prefix=/tools \
--with-sysroot=$LFS \
--target=$LFS_TGT \
--disable-nls \
--enable-gprofng=no \
--disable-werror \
--enable-new-dtags \
--enable-default-hash-style-gnu && \
make && \
make install)

(cd gmp && \
../../gmp-6.3.0/configure \
--prefix=/tools \
--disable-shared \
--enable-static && \
make && \
make install)

(cd mpfr && \
../../mpfr-4.2.1/configure \
--prefix=/tools \
--with-gmp=/tools \
--disable-shared \
--enable-static && \
make && \
make install)

(cd mpc && \
../../mpc-1.3.1/configure \
--prefix=/tools \
--with-gmp=/tools \
--with-mpfr=/tools \
--disable-shared \
--enable-static && \
make && \
make install)

(cd gcc && \
../../gcc-14.2.0/configure \
--prefix=/tools \
--target=$LFS_TGT \
--with-glibc-version=2.40 \
--with-sysroot=$LFS \
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
--with-gmp=/tools \
--with-mpc=/tools \
--with-mpfr=/tools \
--enable-languages=c,c++ && \
make &&
make install)

(cd $LFS/sources/gcc-14.2.0 && \
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h
)

(cd glibc && \
../../glibc-2.40/configure \
--prefix=/usr \
--host=$LFS_TGT \
--build=$(../../glibc-2.40/scripts/config.guess) \
--enable-kernel=4.19 \
--with-headers=$LFS/usr/include \
--disable-nscd \
libc_cv_slibdir=/usr/lib && \
make && \
make DESTDIR=$LFS install && \
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd)

(cd libstdc++ && \
../../gcc-14.2.0/libstdc++-v3/configure \
--prefix=/usr \
--host=$LFS_TGT \
--build=$(../../gcc-14.2.0/config.guess) \
--disable-multilib \
--disable-nls \
--disable-libstdcxx-pch \
--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/14.2.0 && \
make && \
make DESTDIR=$LFS install && \
rm -fv $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la)
```

### Build Phase 2

```sh
#!/bin/sh

cd $LFS/sources/phase1


```