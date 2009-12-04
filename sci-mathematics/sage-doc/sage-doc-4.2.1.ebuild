# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION="${PV}"
SAGE_PACKAGE="sage-${PV}"

inherit distutils python sage

DESCRIPTION="Documentation for Sage"
HOMEPAGE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# TODO: build html, pdf
# TODO: Handle LINGUAS=en,fr

RESTRICT="mirror"

# in fact sage ships twisted-8.2.0
DEPEND=">=dev-python/sphinx-0.6.3
	>=dev-python/twisted-8.1.0
	=sci-mathematics/sage-4.2.1
	virtual/python"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-source-path.patch"
}

src_compile() {
	export SAGE_ROOT=/opt/sage
	export PYTHONPATH="${SAGE_ROOT}"/devel/sage
	export LD_LIBRARY_PATH="${SAGE_ROOT}"/local/lib
	export SAGE_DOC="${S}"/doc
	export SAGE_DOC_SRC="${SAGE_ROOT}"/devel/sage/doc

	# this command is mandatory - builder.py deletes '.' from PYTHONPATH!
	cd "${S}"/doc/common

	# build documentation
	${python} builder.py all html
}

src_install() {
	exit 1
}
