#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=binutils
version=2.24.51-2
url=http://cygwin.parentingamerica.com/x86_64/release/binutils/
d=$package-$version
tar=$d-src.tar.xz

export CFLAGS=${CFLAGS:-"${opt_flags} -I$(echo `pwd`/$d/include|sed 's/ /\\ /g')"}
export CPPFLAGS="${CPPFLAGS} -D__CYGWIN__"
export LDFLAGS="${LDFLAGS} -s -Wl,--enable-auto-import"

configure_options="--prefix=/usr \
	--disable-werror --without-libintl-prefix --without-libiconv-prefix"

xz=xz-5.0.5-windows

download &&
(test -d "$d" || {
 curl -O "http://tukaani.org/xz/$xz.zip" &&
 unzip -d $xz -x $xz.zip 'bin_i486/*' &&
 $xz/bin_i486/xz -dc $tar | tar xf - &&
 rm -rf $xz $xz.zip
}) &&
apply_patches

(cd "$d" && rm -rf gdb)

curl "http://git.savannah.gnu.org/gitweb/?p=autoconf-archive.git;a=blob_plain;f=m4/ax_create_stdint_h.m4" \
	-o "$d"/ax_create_stdint_h.m4
(cd "$d" && autoreconf -ivf . ld) || die "Could not autoreconf"

# Update ltmain.sh version
cp -fp /usr/share/libtool/config/ltmain.sh "$d"/ld/ltmain.sh
(sed 's|^ltmain="$ac_aux_dir/ltmain.sh"|ltmain="./ltmain.sh"|' "$d"/ld/configure > tmp &&
 mv -f tmp "$d"/ld/configure
)

# hack! - libiberty configure tests for header files using "$CPP $CPPFLAGS"
(cd "$d" &&
 sed "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" libiberty/configure > tmp &&
 mv -f tmp libiberty/configure) || die "Could not patch"

setup
compile

# update index
FILELIST=fileList.txt

pre_install

(cd "$d" && make install) || die "Could not install"

post_install
