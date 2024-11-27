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

* Hardware: MacBook Pro 16" 2019
  * CPU: Intel(R) Core(TM) i9-9980HK (8 cores)
  * RAM: 32 GiB
* OS: macOS Sequoia(15.x)
  * Xcode 16.1 (clang 1600.0.26.4)
  * e2fsprogs 1.47.1 (macports)
  * ext4fuse 0.1.3 (macports)

```
$ ./version-check.sh 
ERROR: Coreutils is TOO OLD (2.3 detected, 8.1 or later required)
OK:    Bash      3.2.57 >= 3.2
OK:    Binutils         >= 2.13.1
ERROR: Bison     is TOO OLD (2.3 detected, 2.7 or later required)
OK:    Diffutils        >= 2.8.1
OK:    Findutils        >= 4.2.31
OK:    Gawk      5.3.1  >= 4.0.1
OK:    GCC       16.0.0 >= 5.2
OK:    GCC (C++) 16.0.0 >= 5.2
OK:    Grep      2.6.0  >= 2.5.1a
OK:    Gzip      448.0.3 >= 1.3.12
ERROR: M4        is TOO OLD (1.4.6 detected, 1.4.10 or later required)
ERROR: Make      is TOO OLD (3.81 detected, 4.0 or later required)
ERROR: Patch     is TOO OLD (2.0 detected, 2.5.4 or later required)
OK:    Perl      5.34.1 >= 5.8.8
OK:    Python    3.9.6  >= 3.4
OK:    Sed              >= 4.1.5
OK:    Tar       3.5.3  >= 1.22
OK:    Texinfo   7.1    >= 5.0
OK:    Xz        5.6.3  >= 5.0.0
ERROR: Linux Kernel does NOT support UNIX 98 PTY
Aliases:
ERROR: awk  is NOT GNU
OK:    yacc is Bison
OK:    sh   is Bash
Compiler check:
OK:    g++ works
./version-check.sh: line 86: nproc: command not found
ERROR: nproc is not available or it produces empty output
```
