# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1 toolchain-funcs

DESCRIPTION="BriAL, a successor to PolyBoRI: Polynomials over Boolean Rings"
HOMEPAGE="https://github.com/BRiAl/BRiAl"

SRC_URI="https://github.com/BRiAl/BRiAl/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE="doc static-libs"

RESTRICT="mirror"

CDEPEND=">=dev-libs/boost-1.52.0
	>=sci-libs/m4ri-20090512
	!sci-mathematics/polybori"

DEPEND="virtual/pkgconfig
	${CDEPEND}
	doc? (
		dev-tex/tex4ht
		app-doc/doxygen
	)"
RDEPEND="${CDEPEND}"

pkg_setup(){
	tc-export PKG_CONFIG
}

src_configure(){
	python_configure(){
		default
	}

	python_foreach_impl python_configure
}

src_compile(){
	python_compile(){
		default
	}

	python_foreach_impl python_compile
}

src_install(){
	python_install(){
		default
	}

	python_foreach_impl python_install
	find "${ED}" -name '*.la' -delete || die
}

src_test(){
	python_test(){
		default
	}

	python_foreach_impl python_test
}
