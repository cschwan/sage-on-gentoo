# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit sage

MY_P="examples-${PV}"

DESCRIPTION="Sage examples"
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

src_prepare() {
	# remove mecurial directories
	hg_clean

	# remove files not needed
	rm sage-push spkg-install || die "rm failed"
}

src_install() {
	insinto "${SAGE_ROOT}"/examples
	doins -r * || die "doins failed"
	fperms a+x "${SAGE_ROOT}"/examples/test_all || die "fperms failed"
}
