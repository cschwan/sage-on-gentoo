# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="jupyter jsmol widget viewer"
HOMEPAGE="https://github.com/fekad/jupyter-jsmol"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/ipykernel-4.5.1[${PYTHON_USEDEP}]
	>=dev-python/nbformat-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.3.1[${PYTHON_USEDEP}]
	>=dev-python/widgetsnbextension-3.5.0[${PYTHON_USEDEP}]
	dev-python/ipywidgets[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_compile(){
	distutils-r1_python_compile --skip-npm
}

python_install_all(){
	insinto /usr/share/jupyter/nbextensions/jupyter_jsmol
	doins -r jupyter_jsmol/nbextension/static/*
}
