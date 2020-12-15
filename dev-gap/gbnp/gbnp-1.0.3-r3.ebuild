# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="computing Grobner bases of noncommutative polynomials"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( =sci-mathematics/gap-4.10* >=sci-mathematics/gap-core-4.11.0 )
	>=dev-gap/GAPDoc-1.6.2"

DOCS="README README_AUTHORS TODO Changelog COPYRIGHT"

src_prepare(){
	default
	# The makefile is to produce the package.
	# It should not be run here.
	rm -f GNUmakefile
}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r doc lib
	doins *.g
}
