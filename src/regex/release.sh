#!/bin/sh

cd "$(dirname "$0")" && . ../common/update-lib.sh

check_pristine

package=regex
version=
url=
d=$package
tar=$d.tar.gz

mkdir regex
(test -f /src/msys/regex || {
	git submodule init /src/msys &&
	git submodule update
}) || die "Could not checkout"

(cd "$d" && ../../msys/regex/configure --prefix=/usr
) || die "Could not configure"
(cd "$d" && make) || die "Could not make"

# update index
FILELIST=fileList.txt

pre_install

(cd "$d" && make install) || die "Could not install"

post_install
