# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="jupyter jsmol widget viewer"
HOMEPAGE="https://github.com/fekad/jupyter-jsmol"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

#DISTUTILS_IN_SOURCE_BUILD=1

DEPEND="
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/ipykernel-4.5.1[${PYTHON_USEDEP}]
	>=dev-python/nbformat-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.3.1[${PYTHON_USEDEP}]
	>=dev-python/widgetsnbextension-3.5.0[${PYTHON_USEDEP}]
	dev-python/ipywidgets[${PYTHON_USEDEP}]"
BDEPEND=">=net-libs/nodejs-15.2.0[npm]"

distutils_enable_tests pytest

python_install_all(){
	insinto /usr/share/jupyter/nbextension/jupyter_jsmol
	doins -r jupyter_jsmol/nbextension/static/*
	insinto /usr/share/jupyter/lab/extensions/
	doins jupyter_jsmol/labextension/jupyter-jsmol-0.2.4.tgz
}
