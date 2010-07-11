# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

MY_P="${P}.1.p7"

DESCRIPTION="Computes special values of symmetric power elliptic curve L-functions"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="sci-mathematics/pari"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	local sharedir="${EPREFIX}"/usr/share/sympow

	# fix paths for gp scripts
	sed -i "s:standard\([123]\).gp:${sharedir}/standard\1.gp:g" generate.c \
		|| die "failed to patch gp script pathnames"

	# fix calls to itself - this one first:
	sed -i "s:\.\./sympow:sympow:g" generate.c \
		|| die "failed to patch call to binary"

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

src_install() {
	# install and rename script
	newbin new_data sympow_new_data || die

	# install and rename binary
	newbin sympow sympow_bin || die

	# install wrapper script
	newbin sympow_temp sympow || die

	# install pari scripts and data
	insinto /usr/share/sympow
	doins *.gp || die
	doins -r datafiles || die

	# install docs
	dodoc README || die
}
