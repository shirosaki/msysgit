#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=make
version=4.0
url=ftp://ftp.gnu.org/pub/gnu/$package/
d=$package-$version
tar=$d.tar.bz2

opt_flags="-O3 -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags}"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -s -Wl,--enable-auto-import"

configure_options="--prefix=/usr \
	 ac_cv_dos_paths=yes --without-libintl-prefix --without-libiconv-prefix"

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
