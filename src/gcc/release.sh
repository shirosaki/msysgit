#!/bin/sh

# Based on the build script
# https://github.com/Alexpux/MSYS2-packages/blob/master/gcc/PKGBUILD

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=gcc
version=4.8.2
url=ftp://gcc.gnu.org/pub/gcc/releases/$package-$version
d=$package-$version
tar=$d.tar.bz2

# using -pipe causes spurious test-suite failures
# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48565
CFLAGS=${CFLAGS/-pipe/}
CXXFLAGS=${CXXFLAGS/-pipe/}

export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -s -Wl,--enable-auto-import -Wl,--disable-runtime-pseudo-reloc"
# search gmp library
export PATH=/usr/lib:$PATH
# search msys-gcc_s-*.dll
export PATH="`pwd`/$d/host-i686-pc-msys/gcc/usr/bin:$PATH"


configure_options="--prefix=/usr \
		--libexecdir=/usr/lib \
		--enable-bootstrap \
		--enable-shared --enable-shared-libgcc --enable-static \
		--enable-version-specific-runtime-libs \
		--with-arch=i686 \
		--disable-multilib \
		--with-tune=generic \
		--disable-__cxa_atexit \
		--enable-languages=c,c++,lto \
		--enable-graphite \
		--enable-threads=posix \
		--enable-libatomic \
		--disable-sjlj-exceptions \
		--disable-libgomp \
		--disable-libitm \
		--enable-libquadmath \
		--enable-libquadmath-support \
		--enable-libssp \
		--disable-win32-registry \
		--disable-symvers \
		--with-gnu-ld \
		--with-gnu-as \
		--disable-isl-version-check \
		--enable-checking=release \
		--without-libiconv-prefix \
		--without-libintl-prefix \
		--with-system-zlib"
download &&
extract &&
apply_patches

# Add missing _G_config.h
test -f /include/g++-3/_G_config.h || {
	curl -L "http://downloads.sourceforge.net/project/mingw/Other/Unsupported/MSYS/msysDVLPR/_G_config.h" -o /include/g++-3/_G_config.h || die "Could not download"
}

test -f "$d"/lto-plugin/ltmain.sh || {
	(cd "$d" && autoreconf -ivf lto-plugin) || die "Could not autoreconf"

	# Update ltmain.sh version
	cp -fp /usr/share/libtool/config/ltmain.sh "$d"/lto-plugin/ltmain.sh
	(sed 's|^ltmain="$ac_aux_dir/ltmain.sh"|ltmain="$ac_aux_dir/lto-plugin/ltmain.sh"|' "$d"/lto-plugin/configure > tmp &&
	 mv -f tmp "$d"/lto-plugin/configure
	)
}


# regenerate to fix compile errors
rm -f "$d"/gcc/gengtype-lex.c

setup
(cd "$d" && make -j8) || die "Could not make"

# update index
FILELIST=fileList.txt

pre_install

(cd "$d" && make install) || die "Could not install"

post_install
