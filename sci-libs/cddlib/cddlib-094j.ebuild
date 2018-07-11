# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

# This should have been dealt with versionator in the direction
# 0.94x -> 094x - now we are screwed.
MY_PV="0.94j"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="C implementation of the Double Description Method of Motzkin et al"
HOMEPAGE="https://www.inf.ethz.ch/personal/fukudak/cdd_home/"
SRC_URI="https://github.com/cddlib/cddlib/releases/download/${MY_PV}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs tools"

DEPEND="dev-libs/gmp:0="
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README )

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use tools || rm "${ED}"/usr/bin/*
	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
	use doc && dodoc doc/cddlibman.pdf
}
