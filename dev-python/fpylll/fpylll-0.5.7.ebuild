# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A Python (2 and 3) wrapper for fplll."
HOMEPAGE="https://github.com/fplll/fpylll"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="=sci-libs/fplll-5.4*
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/cysignals[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )"
RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-Do-not-set-library-path.patch
)

distutils_enable_tests pytest

src_test() {
	PY_IGNORE_IMPORTMISMATCH=1 distutils-r1_src_test
}
