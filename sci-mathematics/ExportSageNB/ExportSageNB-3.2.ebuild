# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="This is a tool to convert SageNB notebooks to other formats."
HOMEPAGE="https://github.com/vbraun/ExportSageNB"
SRC_URI="https://github.com/vbraun/ExportSageNB/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/unittest2[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/ipython-4.0.1[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.1.0[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-install.patch
	)

python_test(){
	"${EPYTHON}" -m unittest discover
}
