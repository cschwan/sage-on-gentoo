# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="jupyter jsmol widget viewer"
HOMEPAGE="https://github.com/fekad/jupyter-jsmol"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	>=dev-python/jupyter_packaging-0.12.2[${PYTHON_USEDEP}]
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-python/ipykernel-4.5.1[${PYTHON_USEDEP}]
	>=dev-python/nbformat-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.3.1[${PYTHON_USEDEP}]
	>=dev-python/widgetsnbextension-3.5.0[${PYTHON_USEDEP}]
	dev-python/ipywidgets[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_configure() {
	DISTUTILS_ARGS=(
		--skip-npm
	)
}

python_install_all() {
	distutils-r1_python_install_all

	# Move etc folder in the right place
	dodir /etc/jupyter/nbconfig/notebook.d
	mv "${ED}"/usr/etc/jupyter/nbconfig/notebook.d/jupyter-jsmol.json \
		"${ED}"/etc/jupyter/nbconfig/notebook.d/jupyter-jsmol.json
	# Remove /usr/etc to keep QA happy
	rm -rf "${ED}"/usr/etc
}
