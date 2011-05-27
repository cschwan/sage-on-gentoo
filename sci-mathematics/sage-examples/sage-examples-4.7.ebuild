# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit versionator

SAGE_P="sage-$(replace_version_separator 2 '.')"
MY_P="examples-$(replace_version_separator 2 '.')"

DESCRIPTION="Example code and scripts for Sage"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
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
	doins -r *
	fperms a+x /usr/share/sage/examples/test_all
}
