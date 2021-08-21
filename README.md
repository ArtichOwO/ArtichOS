# ArtichOS
A simple 16 bit operating system, doesn't do much but hey! maybe one day :3
Should boot on real HW, please open an issue if not!
  
## Build instructions
### Prerequisites:
- [nasm](https://www.nasm.us)
- [gcc](https://gcc.gnu.org)
- [qemu](https://www.qemu.org)
- gmp
- mpfr
- libmpc

You can easily install them on linux (`apt install` & `pacman -S`, etc) and with [brew](https://brew.sh) on macOS.

### Cross-compiler/debugger
```bash
export CC=/usr/local/bin/gcc-M.m # Replace M.m with your gcc version
export PREFIX="/usr/local/i386elfgcc"
export TARGET=i386-elf
export PATH="$PREFIX/bin:$PATH"
```
Binutils:
```bash
mkdir /tmp/src
cd /tmp/src
curl -O http://ftp.gnu.org/gnu/binutils/binutils-M.m.tar.gz # Replace M.m with your desired version
tar xf binutils-M.m.tar.gz
mkdir binutils-build
cd binutils-build
../binutils-M.m/configure --target=$TARGET --enable-interwork --enable-multilib --disable-nls --disable-werror --prefix=$PREFIX 2>&1 | tee configure.log
make all install 2>&1 | tee make.log
```
GCC:
```bash
cd /tmp/src
curl -O https://ftp.gnu.org/gnu/gcc/gcc-4.9.1/gcc-M.m.m.tar.bz2 # Replace M.m.m with your desired version
tar xf gcc-M.m.m.tar.bz2
mkdir gcc-build
cd gcc-build
../gcc-M.m.m/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-libssp --enable-languages=c,c++ --without-headers
make all-gcc 
make all-target-libgcc 
make install-gcc 
make install-target-libgcc 
```
You should have all the GNU binutils and the compiler at `/usr/local/i386elfgcc/bin`, prefixed by `i386-elf-` to avoid collisions with your system's compiler and binutils.

GDB:
```bash
cd /tmp/src
curl -O http://ftp.rediris.es/mirror/GNU/gdb/gdb-M.m.tar.gz # Replace M.m with your desired version
tar xf gdb-M.m.tar.gz
mkdir gdb-build
cd gdb-build
export PREFIX="/usr/local/i386elfgcc"
export TARGET=i386-elf
../gdb-7.8/configure --target="$TARGET" --prefix="$PREFIX" --program-prefix=i386-elf-
make
make install
```
When debugging, if you have the error `I'm sorry dave I can't do that. symbol format elf32-i386' unknown` rebuild gdb but add `#include <string.h>` at the top of `elf-bfd.h`, should work now.  

You may want to add the `$PATH` to your `.bashrc`.

### Make
- `all`:  
  Build and launch QEMU
- `build`:  
  Build
- `clean`:  
	Clean `output`
