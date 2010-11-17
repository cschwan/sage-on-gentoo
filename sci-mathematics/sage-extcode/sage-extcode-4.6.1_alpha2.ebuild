# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

#MY_P="extcode-${PV}"
SAGE_PV="4.6.1.alpha2"
SAGE_DIR="sage-${SAGE_PV}"
MY_P="extcode-${SAGE_PV}"

DESCRIPTION="Extcode for Sage"
HOMEPAGE="http://www.sagemath.org"
#SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_DIR}/${SAGE_DIR}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	find . -name "*pyc" -type f -delete \
		|| die "failed to remove precompiled files"
}

src_install() {
	# remove stuff not needed
	rm -rf .hg .hgignore .hgtags mirror sage-push spkg-debian spkg-dist \
		spkg-install dist || die "failed to remove useless files"

	insinto /usr/share/sage/data/extcode
	doins -r * || die
}
