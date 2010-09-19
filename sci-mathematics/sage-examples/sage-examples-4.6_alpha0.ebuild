# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

#MY_P="examples-${PV}"
MY_P="examples-4.6.alpha0"

DESCRIPTION="Example code and scripts for Sage"
HOMEPAGE="http://www.sagemath.org"
#SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"
SRC_URI="http://sage.math.washington.edu/home/release/sage-4.6.alpha0/sage-4.6.alpha0/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# remove stuff not needed
	rm -rf .hg .hgignore .hgtags sage-push spkg-install \
		|| die "failed to remove useless files"
}

src_install() {
	insinto /usr/share/sage/examples
	doins -r * || die
	fperms a+x /usr/share/sage/examples/test_all || die
}
