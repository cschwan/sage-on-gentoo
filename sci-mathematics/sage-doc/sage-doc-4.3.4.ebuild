# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit sage

MY_P="sage-${PV}-doc-html"

DESCRIPTION="Documentation for Sage"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="http://www.sagemath.org/doc-bz2/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=" || ( !sci-mathematics/sage ~sci-mathematics/sage-${PV}[-build-doc] )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto "${SAGE_ROOT}"/devel/sage-main/doc/output/html
	doins -r * || die "doins failed"
}
