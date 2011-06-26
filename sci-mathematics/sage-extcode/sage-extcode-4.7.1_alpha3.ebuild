# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit versionator

SAGE_P="sage-$(replace_version_separator 3 '.')"
MY_P="extcode-$(replace_version_separator 3 '.')"

DESCRIPTION="Extcode for Sage"
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
	find . -name "*pyc" -type f -delete \
		|| die "failed to remove precompiled files"
}

src_install() {
	# remove stuff not needed
	rm -rf .hg .hgignore .hgtags mirror sage-push spkg-debian spkg-dist \
		spkg-install dist || die "failed to remove useless files"

	insinto /usr/share/sage/data/extcode
	doins -r *
}
