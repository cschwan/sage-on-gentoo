# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1 virtualx

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="http://networkx.github.io/ https://github.com/networkx/networkx"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples gdal graphviz pandas scipy test xml yaml"

# not currently building the doc as it require a number of new packages
#REQUIRED_USE="doc? ( || ( $(python_gen_useflags -2) ) )"

COMMON_DEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	gdal? ( sci-libs/gdal[${PYTHON_USEDEP}] )
	graphviz? (
		dev-python/pygraphviz[${PYTHON_USEDEP}]
		dev-python/pydot[${PYTHON_USEDEP}]
	)
	pandas? ( dev-python/pandas[${PYTHON_USEDEP}] )
	scipy? ( sci-libs/scipy[${PYTHON_USEDEP}] )
	xml? ( dev-python/lxml[${PYTHON_USEDEP}] )
	yaml? ( dev-python/pyyaml[${PYTHON_USEDEP}] )"
DEPEND="
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${COMMON_DEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/pydot-1.2.3[${PYTHON_USEDEP}]' -2)
	)"
# 	doc? (
# 		dev-python/sphinx[${PYTHON_USEDEP}]
# 		dev-python/matplotlib[${PYTHON_USEDEP}]
# 		$(python_gen_cond_dep 'dev-python/numpydoc[${PYTHON_USEDEP}]' python2_7)
# 		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
# 		dev-python/sphinx-gallery[${PYTHON_USEDEP}]
# 	)
RDEPEND="
	>=dev-python/decorator-4.1.0[${PYTHON_USEDEP}]
	examples? (
		${COMMON_DEPEND}
		dev-python/pygraphviz[${PYTHON_USEDEP}]
		dev-python/pyparsing[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)"

# python_compile_all() {
# 	if use doc; then
# 		python_setup -2
# 		emake -C doc html
# 	fi
# }

python_test() {
	virtx nosetests -vv || die
}

python_install_all() {
	# Oh my.
	rm -r "${ED}"usr/share/doc/${P} || die

# 	use doc && local HTML_DOCS=( doc/build/html/. )
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
