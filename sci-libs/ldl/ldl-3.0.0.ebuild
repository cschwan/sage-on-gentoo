# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

Sparse_PV="6.0.1"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Simple but educational LDL^T matrix factorization algorithm"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-6.0.1_beta7
	>=sci-libs/amd-3.0.0"
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
	# Some programs assume that they can access the Matrix folder in ${S}
	ln -s "${S}/Matrix"
	# Run demo files
	./ldlsimple > ldlsimple.out
	diff "${S}"/Demo/ldlsimple.out ldlsimple.out || die "failed testing"
	./ldllsimple > ldllsimple.out
	diff "${S}"/Demo/ldllsimple.out ldllsimple.out || die "failed testing"
	./ldlmain > ldlmain.out
	diff "${S}"/Demo/ldlmain.out ldlmain.out || die "failed testing"
	./ldllmain > ldllmain.out
	diff "${S}"/Demo/ldlmain.out ldllmain.out || die "failed testing"
	./ldlamd  > ldlamd.out
	diff "${S}"/Demo/ldlamd.out ldlamd.out || die "failed testing"
	./ldllamd  > ldllamd.out
	diff "${S}"/Demo/ldllamd.out ldllamd.out || die "failed testing"
}

multilib_src_install() {
	if use doc; then
		pushd "${S}/Doc"
		rm -rf *.pdf
		emake
		popd
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
