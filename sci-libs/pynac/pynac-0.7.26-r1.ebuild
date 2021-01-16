# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6..9} )

inherit autotools python-r1 vcs-snapshot

DESCRIPTION="A modified version of GiNaC that replaces the dependency on CLN by Python"
HOMEPAGE="https://pynac.sagemath.org/ https://github.com/pynac/pynac"
SRC_URI="https://github.com/pynac/pynac/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="static-libs +giac"

RESTRICT=primaryuri

DEPEND="dev-libs/gmp:0=
	>=sci-mathematics/flint-2.5.2-r1
	>=sci-mathematics/singular-4.0.3_p3
	giac? ( >=sci-mathematics/giac-1.2.2 )
	virtual/pkgconfig
	${PYTHON_DEPS}"
RDEPEND="dev-libs/gmp:0=
	>=sci-mathematics/flint-2.5.2-r1
	>=sci-mathematics/singular-4.0.3_p3
	giac? ( >=sci-mathematics/giac-1.2.2 )
	${PYTHON_DEPS}"

DOCS=( AUTHORS NEWS README )

PATCHES=(
	"${FILESDIR}"/un-pc-0.7.22.patch
	"${FILESDIR}"/PR354.patch
	)

src_prepare(){
	pynac_prepare(){
		cd "${BUILD_DIR}" || die

		sed -i "s:libpynac:libpynac_${MULTIBUILD_VARIANT}:g" \
			ginac/Makefile.am
		eautoreconf
	}

	default
	python_copy_sources
	python_foreach_impl pynac_prepare
}

src_configure(){
	pynac_configure(){
		cd "${BUILD_DIR}" || die
		econf \
			$(use_with giac) \
			$(use_enable static-libs static)
	}

	python_foreach_impl pynac_configure
}

src_compile(){
	pynac_compile(){
		cd "${BUILD_DIR}" || die
		default
	}
	python_foreach_impl pynac_compile
}

src_install(){
	pynac_install(){
		cd "${BUILD_DIR}" || die
		default
	}

	python_foreach_impl pynac_install
	# remove .la file
	find "${ED}" -name '*.la' -delete || die
}
