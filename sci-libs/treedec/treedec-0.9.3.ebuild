# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="tree decomposition algorithms"
HOMEPAGE="https://github.com/freetdi/tdlib"
SRC_URI="https://www.algok.uni-bamberg.de/treedec/${P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

# test requires gala - a badly documented dependency
RESTRICT="test"

src_configure() {
	# python support is old?
	econf --with-python=no
}
