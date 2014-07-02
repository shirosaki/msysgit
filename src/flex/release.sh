#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=flex
version=2.5.39
url=http://downloads.sourceforge.net/sourceforge/flex
d=$package-$version
tar=$d.tar.bz2

opt_flags="-O3 -s -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags}"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -Wl,--enable-auto-import -lregex"

configure_options="--prefix=/usr \
	--without-libiconv-prefix \
	--without-libintl-prefix \
	--enable-static \
	--disable-shared"

download &&
extract &&
apply_patches

setup
compile

# update index
FILELIST=fileList.txt

pre_install

(cd "$d" && make install) || die "Could not install"

post_install
