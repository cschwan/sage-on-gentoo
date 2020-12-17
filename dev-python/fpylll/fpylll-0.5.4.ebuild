# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

DESCRIPTION="A Python (2 and 3) wrapper for fplll."
HOMEPAGE="https://github.com/fplll/fpylll"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="~sci-libs/fplll-5.4.0
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
