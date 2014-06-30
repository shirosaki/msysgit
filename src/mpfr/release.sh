#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=mpfr
version=3.1.2
url=http://www.mpfr.org/mpfr-current/
d=$package-$version
tar=$d.tar.gz

opt_flags="-O3 -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags}"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -s -Wl,--enable-auto-import"
# search gmp library
export PATH=/usr/lib:$PATH

configure_options="--prefix=/usr \
	--enable-shared \
	--disable-static"

download &&
extract &&
apply_patches

(cd "$d" && autoreconf -ivf) || die "Could not autoreconf"

setup
compile

# update index
FILELIST=fileList.txt

pre_install

(cd "$d" && make install) || die "Could not install"

post_install
