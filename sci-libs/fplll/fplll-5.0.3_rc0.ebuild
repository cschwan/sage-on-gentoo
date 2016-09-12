# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

MY_PV="$(delete_version_separator 3)"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Different implementations of the floating-point LLL reduction algorithm"
HOMEPAGE="https://github.com/fplll/fplll"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${MY_PV}/${MY_P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=">=dev-libs/gmp-4.2.0:0
	>=dev-libs/mpfr-2.3.0:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		$(use_enable static-libs static)
}
