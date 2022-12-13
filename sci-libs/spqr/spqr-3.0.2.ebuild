# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib toolchain-funcs

Sparse_PV="6.0.2"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Multithreaded multifrontal sparse QR factorization library"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc openmp test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-6.0.2
	>=sci-libs/amd-3.0.2
	>=sci-libs/colamd-3.0.2
	>=sci-libs/cholmod-4.0.2
	virtual/blas"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

S="${WORKDIR}/${Sparse_P}/${PN^^}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

multilib_src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DNOPENMP=$(usex openmp OFF ON)
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	# Run demo files
	./qrsimple  < "${S}"/Matrix/ash219.mtx
	./qrsimplec < "${S}"/Matrix/ash219.mtx
	./qrsimple  < "${S}"/Matrix/west0067.mtx
	./qrsimplec < "${S}"/Matrix/west0067.mtx
	./qrdemo < "${S}"/Matrix/a2.mtx
	./qrdemo < "${S}"/Matrix/r2.mtx
	./qrdemo < "${S}"/Matrix/a04.mtx
	./qrdemo < "${S}"/Matrix/a2.mtx
	./qrdemo < "${S}"/Matrix/west0067.mtx
	./qrdemo < "${S}"/Matrix/c2.mtx
	./qrdemo < "${S}"/Matrix/a0.mtx
	./qrdemo < "${S}"/Matrix/lfat5b.mtx
	./qrdemo < "${S}"/Matrix/bfwa62.mtx
	./qrdemo < "${S}"/Matrix/LFAT5.mtx
	./qrdemo < "${S}"/Matrix/b1_ss.mtx
	./qrdemo < "${S}"/Matrix/bcspwr01.mtx
	./qrdemo < "${S}"/Matrix/lpi_galenet.mtx
	./qrdemo < "${S}"/Matrix/lpi_itest6.mtx
	./qrdemo < "${S}"/Matrix/ash219.mtx
	./qrdemo < "${S}"/Matrix/a4.mtx
	./qrdemo < "${S}"/Matrix/s32.mtx
	./qrdemo < "${S}"/Matrix/c32.mtx
	./qrdemo < "${S}"/Matrix/lp_share1b.mtx
	./qrdemo < "${S}"/Matrix/a1.mtx
	./qrdemo < "${S}"/Matrix/GD06_theory.mtx
	./qrdemo < "${S}"/Matrix/GD01_b.mtx
	./qrdemo < "${S}"/Matrix/Tina_AskCal_perm.mtx
	./qrdemo < "${S}"/Matrix/Tina_AskCal.mtx
	./qrdemo < "${S}"/Matrix/GD98_a.mtx
	./qrdemo < "${S}"/Matrix/Ragusa16.mtx
	./qrdemo < "${S}"/Matrix/young1c.mtx
	./qrdemo < "${S}"/Matrix/lp_e226_transposed.mtx
	./qrdemoc < "${S}"/Matrix/a2.mtx
	./qrdemoc < "${S}"/Matrix/r2.mtx
	./qrdemoc < "${S}"/Matrix/a04.mtx
	./qrdemoc < "${S}"/Matrix/a2.mtx
	./qrdemoc < "${S}"/Matrix/west0067.mtx
	./qrdemoc < "${S}"/Matrix/c2.mtx
	./qrdemoc < "${S}"/Matrix/a0.mtx
	./qrdemoc < "${S}"/Matrix/lfat5b.mtx
	./qrdemoc < "${S}"/Matrix/bfwa62.mtx
	./qrdemoc < "${S}"/Matrix/LFAT5.mtx
	./qrdemoc < "${S}"/Matrix/b1_ss.mtx
	./qrdemoc < "${S}"/Matrix/bcspwr01.mtx
	./qrdemoc < "${S}"/Matrix/lpi_galenet.mtx
	./qrdemoc < "${S}"/Matrix/lpi_itest6.mtx
	./qrdemoc < "${S}"/Matrix/ash219.mtx
	./qrdemoc < "${S}"/Matrix/a4.mtx
	./qrdemoc < "${S}"/Matrix/s32.mtx
	./qrdemoc < "${S}"/Matrix/c32.mtx
	./qrdemoc < "${S}"/Matrix/lp_share1b.mtx
	./qrdemoc < "${S}"/Matrix/a1.mtx
	./qrdemoc < "${S}"/Matrix/GD06_theory.mtx
	./qrdemoc < "${S}"/Matrix/GD01_b.mtx
	./qrdemoc < "${S}"/Matrix/Tina_AskCal_perm.mtx
	./qrdemoc < "${S}"/Matrix/Tina_AskCal.mtx
	./qrdemoc < "${S}"/Matrix/GD98_a.mtx
	./qrdemoc < "${S}"/Matrix/Ragusa16.mtx
	./qrdemoc < "${S}"/Matrix/young1c.mtx
	./qrdemoc < "${S}"/Matrix/lp_e226_transposed.mtx
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
