# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

MY_P="database_symbolic_data-${PV}"

DESCRIPTION=""
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/optional/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/sage/data/symbolic_data
	doins -r Data || die
}
