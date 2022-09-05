# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A library and set of programs for working with matrices over finite fields"
HOMEPAGE="http://users.minet.uni-jena.de/~king/SharedMeatAxe/
	https://github.com/simon-king-jena/SharedMeatAxe/"
SRC_URI="https://github.com/simon-king-jena/SharedMeatAxe/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

export MTXLIB="${T}/meataxe"

src_compile() {
	default

	# build and install the multiplication tables
	mkdir "${MTXLIB}"
	cd "${MTXLIB}"
	einfo "building the multiplication tables"
	for i in 2 3 4 5 7 8 9 11 13 16 17 19 23 25 27 29 31 32 37 41 43 47 49 53 59 61 64 67 71 73 79 81 83 89 97 101 103 107 109 113 121 125 127 128 131 137 139 149 151 157 163 167 169 173 179 181 191 193 197 199 211 223 227 229 233 239 241 243 251
	do
		"${S}/src"/zcv <(echo "matrix field=$i rows=0 cols=0") /dev/null \
			||  die "Error creating multiplication table for field of size $i"
	done
}

src_install() {
	default

	# remove .la file
	find "${ED}" -name '*.la' -delete || die

	# install the multiplication tables
	insinto usr/share/meataxe
	doins "${MTXLIB}"/*
}
