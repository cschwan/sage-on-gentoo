# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

MY_P="database_stein_watkins_mini.p0"

DESCRIPTION=""
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/optional/${MY_P}.spkg -> ${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/sage/data
	doins -r stein-watkins-ecdb || die
}
