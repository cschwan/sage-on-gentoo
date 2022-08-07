# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PV=$(ver_cut 1-3).post$(ver_cut 5)
MY_PN="qdldl"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="A Python wrapper for qdldl"
HOMEPAGE="https://pypi.org/project/qdldl/
	https://github.com/osqp/qdldl-python"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

# Notes: the package bundles customised version of amd and qdldl.
# The customisation makes it impossible to unvendor.
BDEPEND="dev-util/cmake"
DEPEND="dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest
