# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="computes Groebner fans and tropical varities"
HOMEPAGE="http://home.math.au.dk/jensen/software/gfan/gfan.html"
SRC_URI="mirror://sageupstream/gfan/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-libs/gmp[cxx]
	sci-libs/cddlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}/"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.2-xcode9.3_compat.patch"
	"${FILESDIR}/${PN}-0.6.2-testsuite.patch"
	"${FILESDIR}/${PN}-0.6.2-Makefile.patch"
	)

pkg_setup() {
	tc-export CC CXX
	append-cxxflags -DNOCDDPREFIX
}

src_install() {
	emake PREFIX="${ED}/usr" install
}
