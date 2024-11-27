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
apt update && \
apt -y install binutils bison gawk gcc g++ \
  git gparted m4 make patch texinfo vim && \
apt clean all
savechanges slax-lfs.sb
genslaxiso slax-lfs.iso slax-lfs.sb
```
