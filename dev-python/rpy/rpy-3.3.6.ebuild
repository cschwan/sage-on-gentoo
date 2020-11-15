# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

MYSLOT=2
MY_PN=${PN}${MYSLOT}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python interface to the R Programming Language"
HOMEPAGE="https://rpy2.github.io/
	https://pypi.org/project/rpy2/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="AGPL-3 GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-lang/R-3.3
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.13.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-lang/R-3.3[png]
		dev-python/hypothesis
	 )
	dev-python/setuptools[${PYTHON_USEDEP}]"
PDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

S="${WORKDIR}/${MY_P}"
