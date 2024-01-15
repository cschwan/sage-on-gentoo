# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

Sparse_PV="7.5.1"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="a software package for SParse EXact algebra"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.3.1
	>=sci-libs/colamd-3.3.1
	dev-libs/gmp
	dev-libs/mpfr"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-demo_location.patch"
	)

S="${WORKDIR}/${Sparse_P}/${PN^^}"

src_configure() {
	# Define SUITESPARSE_INCLUDEDIR_POSTFIX to "" otherwise it take
	# the value suitesparse, and the include directory would be set to
	# /usr/include/suitesparse
	# This need to be set in all suitesparse ebuilds.
	local mycmakeargs=(
		-DNSTATIC=ON
		-DSUITESPARSE_DEMOS=$(usex test)
		-DSUITESPARSE_INCLUDEDIR_POSTFIX=""
	)
	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}" || die
	# Programs expect to find ExampleMats
	ln -s "${S}/SPEX_Left_LU/ExampleMats"
	# Run demo files
	./example || die "failed testing"
	./example2 || die "failed testing"
	./spexlu_demo || die "failed testing"
}

src_install() {
	if use doc; then
		pushd "${S}/Doc" || die
		emake clean
		rm -rf *.pdf || die
		emake
		popd || die
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
