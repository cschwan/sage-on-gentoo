# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="This wrapper-kernel is a Jupyter kernel for GAP"
HOMEPAGE="https://github.com/gap-packages/jupyter-kernel-gap"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/ipython-5.0.0
	>=sci-mathematics/gap-4.8.6"
RDEPEND="${DEPEND}"
