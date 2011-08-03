# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils versionator

MY_P="$(replace_version_separator 4 '.' ${P})"
SAGE_P="sage-4.6"

DESCRIPTION="Computes special values of symmetric power elliptic curve L-functions"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="pari24"

RESTRICT="mirror"

DEPEND=""
RDEPEND="pari24? ( =sci-mathematics/pari-2.4.3-r1 )
	!pari24? ( >=sci-mathematics/pari-2.5.0 )"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	local sharedir="${EPREFIX}"/usr/share/sympow

	# fix paths for gp scripts
	sed -i "s:standard\([123]\).gp:${sharedir}/standard\1.gp:g" generate.c \
		|| die "failed to patch gp script pathnames"

	# fix calls to itself - this one first:
	sed -i "s:\.\./sympow:sympow:g" generate.c \
		|| die "failed to patch call to binary"

	if use pari24 ; then
		sed -e "s:whichexe gp:whichexe gp-2.4:" \
			-e "s:find gp:find gp-2.4:" \
			-i Configure || die "failed to convert to pari24 usage"
	fi

	# must come after "if use pari24 ..."
	sed -i "s:whichexe :which :g" Configure \
		|| die "failed to patch Configure script"

	# now this:
	sed -i "s:\./sympow:sympow:g" disk.c new_data README \
		|| die "failed to patch call to binary"

	# rename script to avoid possible file conflicts
	sed -i "s:\"new_data\":\"sympow_new_data\":g" generate.c \
		|| die "failed to patch call to new_data script"

	# create wrapper script so that sympow may read and write data files
	cat > sympow_temp <<-EOF
		#!/bin/sh

		DATA="\${HOME}"/.sympow/datafiles

		if [ ! -d "\${DATA}" ]; then
		    mkdir -p "\${DATA}"
		    cp "${EPREFIX}"/usr/share/sympow/datafiles/* "\${DATA}"
		fi

		cd "\${HOME}"/.sympow
		exec sympow_bin "\$@"
	EOF

	chmod go+rx sympow_temp \
		|| die "failed to change permissions of wrapper script"
}

src_configure() {
	./Configure || die "failed to configure sources"
}

src_compile() {
	emake CC="$(tc-getCC)" OPT=
}

src_install() {
	# install and rename script
	newbin new_data sympow_new_data

	# install and rename binary
	newbin sympow sympow_bin

	# install wrapper script
	newbin sympow_temp sympow

	# install pari scripts and data
	insinto /usr/share/sympow
	doins *.gp
	doins -r datafiles

	# install docs
	dodoc README
}
