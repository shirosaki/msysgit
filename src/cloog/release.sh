#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=cloog
version=0.18.1
url=http://www.bastoul.net/cloog/pages/download/
d=$package-$version
tar=$d.tar.gz

opt_flags="-O3 -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags} -I$(echo `pwd`/$d/include|sed 's/ /\\ /g')"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -s -Wl,--enable-auto-import"
# search gmp library
export PATH=/usr/lib:$PATH

configure_options="--prefix=/usr \
	--enable-shared \
	--disable-static \
	--with-isl=system \
	--with-bits-gmp \
	--program-suffix=-isl"

download &&
extract &&
(cd "$d" && rm .gitignore isl/.gitignore) &&
apply_patches

curl "http://git.savannah.gnu.org/gitweb/?p=autoconf-archive.git;a=blob_plain;f=m4/ax_create_stdint_h.m4" \
	-o "$d"/m4/ax_create_stdint_h.m4
(cd "$d" && autoreconf -ivf) || die "Could not autoreconf"

setup
compile

# update index
FILELIST=fileList.txt

pre_install

(cd "$d" && make install) || die "Could not install"

post_install
