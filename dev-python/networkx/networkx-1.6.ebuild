# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/networkx/networkx-1.6.ebuild,v 1.3 2011/12/19 07:24:00 zmedico Exp $

EAPI="3"
PYTHON_DEPEND="*:2.6"
#SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.*"

inherit distutils

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="http://networkx.lanl.gov http://pypi.python.org/pypi/networkx"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc examples"

DEPEND="dev-python/setuptools
		doc? (
			dev-python/matplotlib
			dev-python/pygraphviz
			dev-python/sphinx
		)"
RDEPEND="examples? (
		dev-python/matplotlib
		dev-python/pygraphviz
		dev-python/pyparsing
		dev-python/pyyaml
		sci-libs/scipy
	)"

src_compile() {
	distutils_src_compile

	if use doc; then
		# PYTHONPATH is necessary to use networkx to be installed.
		cd "${S}/doc" && PYTHONPATH="${S}" make html \
			|| die "doc compilation failed"
	fi
}

src_install() {
	distutils_src_install
	rm -f "${ED}"usr/share/doc/${PF}/{INSTALL,LICENSE}.txt
	use examples || rm -r "${ED}"usr/share/doc/${PF}/examples
	use doc && dohtml -r doc/build/html/*
}
