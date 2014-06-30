#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=automake
version=1.11.6
url=ftp://ftp.gnu.org/pub/gnu/$package/
d=$package-$version
tar=$d.tar.gz

opt_flags="-O3 -s -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags}"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -Wl,--enable-auto-import"

configure_options="--prefix=/usr"

download &&
extract # &&
# apply_patches

setup
compile

# update index
FILELIST=fileList.txt

pre_install

(cd "$d" && make install) || die "Could not install"

post_install
