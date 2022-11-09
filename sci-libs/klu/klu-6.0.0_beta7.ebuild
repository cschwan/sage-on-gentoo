# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib fortran-2

Sparse_PV=$(ver_rs 3 '-')
Sparse_PN="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Sparse LU factorization for circuit simulation"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_PN}.gh.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="~sci-libs/suitesparseconfig-${PV}
	~sci-libs/amd-${PV}
	~sci-libs/btf-${PV}
	~sci-libs/colamd-${PV}
	~sci-libs/cholmod-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${Sparse_PN}/${PN^^}"

multilib_src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	# Run demo files
	./klu_simple
	./kludemo  < "${S}"/Matrix/1c.mtx || die "failed testing"
	./kludemo  < "${S}"/Matrix/arrowc.mtx || die "failed testing"
	./kludemo  < "${S}"/Matrix/arrow.mtx || die "failed testing"
	./kludemo  < "${S}"/Matrix/impcol_a.mtx || die "failed testing"
	./kludemo  < "${S}"/Matrix/w156.mtx || die "failed testing"
	./kludemo  < "${S}"/Matrix/ctina.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/1c.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/arrowc.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/arrow.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/impcol_a.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/w156.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/ctina.mtx || die "failed testing"
}
