#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=ncurses
version=5.9
url=http://invisible-island.net/datafiles/current/
d=$package-$version-20140629
tar=$package.tar.gz

opt_flags="-O3 -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags}"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -s -Wl,--enable-auto-import"

configure_options="--prefix=/usr \
	--without-ada \
	--with-shared \
	--with-cxx-shared \
	--with-normal \
	--without-debug \
	--disable-relink \
	--disable-rpath \
	--with-ticlib \
	--without-termlib \
	--enable-widec \
	--enable-ext-colors \
	--enable-ext-mouse \
	--enable-sp-funcs \
	--with-wrap-prefix=ncwrap_ \
	--enable-sigwinch \
	--enable-term-driver \
	--enable-colorfgdg \
	--enable-tcap-names \
	--disable-termcap \
	--disable-mixed-case \
	--with-pkg-config \
	--enable-pc-files \
	--with-manpage-format=normal \
	--with-manpage-aliases \
	--with-default-terminfo-dir=/usr/share/terminfo \
	--enable-echo \
	--mandir=/usr/share/man \
	--includedir=/usr/include/ncursesw \
	--with-build-cflags=-D_XOPEN_SOURCE_EXTENDED \
	--with-pkg-config-libdir=/usr/lib/pkgconfig"

download &&
extract

setup
compile

# update index
FILELIST=fileList.txt

pre_install

(cd "$d" && make install) || die "Could not install"

post_install
