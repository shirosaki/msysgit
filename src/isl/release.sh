#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=isl
version=0.12.1
url=http://isl.gforge.inria.fr/
d=$package-$version
tar=${d}.tar.bz2

opt_flags="-O3 -s -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags} -I./include/isl"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -Wl,--enable-auto-import"
# search gmp library
export PATH=/usr/lib:$PATH

configure_options="--prefix=/usr \
	--enable-shared --disable-static"

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
