#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=libtool
version=2.4.2
url=http://ftp.gnu.org/gnu/libtool
d=libtool-$version
tar=$d.tar.gz

opt_flags="-O3 -s -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags}"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -Wl,--enable-auto-import"
# don't use old config.site of msys
export CONFIG_SITE=/dev/null

configure_options="--prefix=/usr"

download &&
extract &&
apply_patches &&
setup &&
compile

# update index
FILELIST=fileList.txt

pre_install

(cd $d && make install) || exit

post_install

