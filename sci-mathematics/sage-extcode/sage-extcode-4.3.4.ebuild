# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit sage

MY_P="extcode-${PV}"

DESCRIPTION="Extcode for Sage"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto "${SAGE_DATA}"/extcode

	# remove mercurial stuff
	hg_clean

	rm -r mirror sage-push spkg-debian spkg-dist spkg-install || die "rm failed"

	doins -r * || die "doins failed"
}
