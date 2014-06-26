#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=m4
version=1.4.16
url=ftp://ftp.gnu.org/pub/gnu/$package/
d=$package-$version
tar=$d.tar.gz

opt_flags="-O3 -s -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags}"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__ -DWEOF='((wint_t)-1)' -DEILSEQ=138"
export LDFLAGS="${LDFLAGS} -Wl,--enable-auto-import"

configure_options="--prefix=/usr \
	--disable-assert \
	--disable-rpath \
	gl_cv_func_strstr_linear=no"

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
