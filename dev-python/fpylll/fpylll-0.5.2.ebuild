# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

MY_PV="${PV}dev"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="A Python (2 and 3) wrapper for fplll."
HOMEPAGE="https://github.com/fplll/fpylll"
SRC_URI="https://github.com/fplll/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND=">=sci-libs/fplll-5.3.1
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/cysignals[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-Do-not-set-library-path.patch
)

S="${WORKDIR}/${MY_P}"

python_test(){
	PY_IGNORE_IMPORTMISMATCH=1 py.test -v
}
