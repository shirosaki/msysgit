#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=texinfo
version=5.2
url=ftp://ftp.gnu.org/pub/gnu/$package/
d=$package-$version
tar=$d.tar.gz

opt_flags="-O3 -s -march=i386"
export CFLAGS=${CFLAGS:-"${opt_flags} -I/usr/include/ncursesw"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -Wl,--enable-auto-import -L/usr/lib/ncursesw"
export HELP2MAN=true

configure_options="--prefix=/usr \
	--without-libiconv-prefix \
	--without-libintl-prefix \
	gl_cv_func_wcwidth_works=yes \
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
