# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="A Python wrapper for the Parma Polyhedra Library (PPL)"
HOMEPAGE="https://github.com/videlec/pplpy"
SRC_URI="https://github.com/videlec/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/gmpy
	dev-python/cysignals
	dev-python/cython
	>=dev-libs/ppl-1.2"
RDEPEND="${DEPEND}"

python_test(){
	cd "${S}"/tests
	"${EPYTHON}" rundoctest.py
}
