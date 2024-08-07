# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

Sparse_PV="7.8.0"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="a software package for SParse EXact algebra"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

S="${WORKDIR}/${Sparse_P}/${PN^^}"
LICENSE="BSD"
SLOT="0/3"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.3.1
	>=sci-libs/colamd-3.3.2
	dev-libs/gmp
	dev-libs/mpfr"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

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
	# Run demo files
	./spex_demo_lu_simple1
	./spex_demo_lu_simple2          "${S}"/ExampleMats/10teams.mat.txt   "${S}"/ExampleMats/10teams.rhs.txt
	./spex_demo_lu_extended       f "${S}"/ExampleMats/10teams.mat.txt   "${S}"/ExampleMats/10teams.rhs.txt
	./spex_demo_lu_doub           f "${S}"/ExampleMats/10teams.mat.txt   "${S}"/ExampleMats/10teams.rhs.txt
	./spex_demo_backslash         f "${S}"/ExampleMats/10teams.mat.txt   "${S}"/ExampleMats/10teams.rhs.txt
	./spex_demo_cholesky_simple   f "${S}"/ExampleMats/494_bus.mat.txt   "${S}"/ExampleMats/494_bus.rhs.txt
	./spex_demo_cholesky_extended f "${S}"/ExampleMats/494_bus.mat.txt   "${S}"/ExampleMats/494_bus.rhs.txt
	./spex_demo_threaded          f "${S}"/ExampleMats/10teams.mat.txt   "${S}"/ExampleMats/10teams.rhs.txt
	./spex_demo_backslash         f "${S}"/ExampleMats/Trefethen_500.mat.txt "${S}"/ExampleMats/Trefethen_500.rhs.txt
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
