# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_AUTORECONF=1

inherit python-r1 autotools-utils toolchain-funcs

DESCRIPTION="BriAL, a successor to PolyBoRI: Polynomials over Boolean Rings"
HOMEPAGE="https://github.com/BRiAl/BRiAl"

SRC_URI="https://github.com/BRiAl/BRiAl/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE="doc static-libs"

RESTRICT="mirror"

CDEPEND=">=dev-libs/boost-1.52.0[python,${PYTHON_USEDEP}]
	>=sci-libs/m4ri-20090512
	!sci-mathematics/polybori"

DEPEND="virtual/pkgconfig
	${CDEPEND}
	doc? (
		dev-tex/tex4ht
		app-doc/doxygen
	)"
RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.4.3-g++_linking.patch
	)

pkg_setup(){
	tc-export PKG_CONFIG
}

src_configure(){
	python_configure(){
		autotools-utils_src_configure
	}

	python_foreach_impl python_configure
}

src_compile(){
	python_compile(){
		autotools-utils_src_compile
	}

	python_foreach_impl python_compile
}

src_install(){
	python_install(){
		autotools-utils_src_install
	}

	python_foreach_impl python_install
}

src_test(){
	python_test(){
		autotools-utils_src_test
	}

	python_foreach_impl python_test
}
