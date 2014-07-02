#!/bin/sh

# Make sure that the working directory is clean and does not have untracked
# files; otherwise our semi-automatic finding the new files will not work!

die () {
	echo "$*" >&2
	exit 1
}

check_pristine () {
	(cd / &&
	 git diff-files --ignore-submodules --quiet &&
	 git diff-index --cached --ignore-submodules --quiet HEAD &&
	 others="$(git ls-files --exclude-standard --others)" &&
	 test -z "$others") ||
		die "State not pristine enough for successful package update"
}

# Remove old files stored in fileList.txt
pre_install () {
	test -z "$FILELIST" && {
		echo "No file list specified for pre_install"
		exit 1
	}
	! test -s "$FILELIST" ||
		cat "$FILELIST" | (cd / && xargs -n 200 git rm --ignore-unmatch) ||
		exit
}

# update the index 
post_install () {
	(cd / && git add -N .) || exit

	git diff --cached --ignore-submodules --diff-filter=AM --name-only |
		sed -e "s/^/\//" > "$FILELIST" ||
		exit
		
	git add "$FILELIST" || exit

	echo "Successfully built and installed $package $version"
	echo "After checking the result, please commit (possibly with --amend)"
	echo
}

download () {
	test -z "$tar" &&
		die "Script did not specify an archive"
	test -f "$tar" || {
		echo "Downloading $tar ..."
		curl -L $url/$tar -o $tar || exit
	}
}

extract () {
	test -z "$d" &&
		die "Script did not specify a directory"
	test -d "$d" || {
		echo "Unpacking $tar ..."
		case "$tar" in
		*.tar.gz|*.tgz)
			tar -xzf "$tar"
			;;
		*.tar.bz2|*.tbz)
			tar -xjf "$tar"
			;;
		*.zip)
			unzip "$tar"
			;;
		esac || exit
	}
}

apply_patches () {
	test -d "$d"/.git && return
	patchdir="$(pwd)"/patches
	(cd "$d" &&
	 GIT_TEMPLATE_DIR= git init &&
	 git config --local core.autocrlf false &&
	 git add . &&
	 git commit -m initial &&
	 for p in "$patchdir"/*.patch
	 do
		git am --whitespace=fix "$p" || exit
	 done) ||
	exit
}

setup () {
	test -z "$d" &&
		die "Script did not specify a directory"
	test -f "$d/Makefile" ||
		(cd "$d" && ./configure $configure_options) || exit
}

compile () {
	test -z "$d" &&
		die "Script did not specify a directory"
	(cd "$d" && make) || exit
}

download_extract_setup_and_compile () {
	download &&
	extract &&
	setup &&
	compile || exit
}
