# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib fortran-2

Sparse_PV="6.0.1"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Library to order a sparse matrix prior to Cholesky factorization"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-6.0.1_beta7"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

S="${WORKDIR}/${Sparse_P}/${PN^^}"

multilib_src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	# Run demo files
	./amd_demo > amd_demo.out
	diff "${S}"/Demo/amd_demo.out amd_demo.out || die "failed testing"
	./amd_l_demo > amd_l_demo.out
	diff "${S}"/Demo/amd_l_demo.out amd_l_demo.out || die "failed testing"
	./amd_demo2 > amd_demo2.out
	diff "${S}"/Demo/amd_demo2.out amd_demo2.out || die "failed testing"
	./amd_simple > amd_simple.out
	diff "${S}"/Demo/amd_simple.out amd_simple.out || die "failed testing"
	./amd_f77simple > amd_f77simple.out
	diff "${S}"/Demo/amd_f77simple.out amd_f77simple.out || die "failed testing"
	./amd_f77demo > amd_f77demo.out
	diff "${S}"/Demo/amd_f77demo.out amd_f77demo.out || die "failed testing"
	einfo "All tests passed"
}

multilib_src_install() {
	if use doc; then
		pushd "${S}/Doc"
		emake clean
		rm -rf *.pdf
		emake
		popd
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
