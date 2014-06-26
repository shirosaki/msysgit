#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=gmp
version=6.0.0
url=ftp://ftp.gmplib.org/pub/gmp-${version}/
d=$package-$version
tar=${d}a.tar.bz2

opt_flags="-O3 -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags}"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -s -Wl,--enable-auto-import"

configure_options="--prefix=/usr \
	--enable-fat \
	--enable-shared --disable-static"

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
