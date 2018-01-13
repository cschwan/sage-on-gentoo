# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PID=37307

DESCRIPTION="Multiple precision interval arithmetic library based on MPFR"
HOMEPAGE="http://perso.ens-lyon.fr/nathalie.revol/software.html"
SRC_URI="https://gforge.inria.fr/frs/download.php/${PID}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="dev-libs/gmp:0=
	dev-libs/mpfr:0="
RDEPEND="${DEPEND}"

src_configure(){
	econf \
		$(use_enable static-libs static)
}
