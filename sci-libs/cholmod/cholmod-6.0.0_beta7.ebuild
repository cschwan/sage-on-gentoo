# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib fortran-2 toolchain-funcs

MY_PV=$(ver_rs 3 '-')
TOPNAME="SuiteSparse-${MY_PV}"
DESCRIPTION="Common configurations for all packages in suitesparse"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${MY_PV}.tar.gz -> ${TOPNAME}.gh.tar.gz"

LICENSE="LGPL-2.1+ modify? ( GPL-2+ ) matrixops? ( GPL-2+ )"
SLOT="0/4"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+cholesky cuda openmp +matrixops +modify +partition +supernodal"

DEPEND="~sci-libs/suitesparseconfig-${PV}
	~sci-libs/amd-${PV}
	~sci-libs/colamd-${PV}
	supernodal? ( virtual/lapack )
	partition? (
		sci-libs/camd
		sci-libs/ccolamd
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit
		x11-drivers/nvidia-drivers
	)"
RDEPEND="${DEPEND}"

REQUIRED_USE="cholesky? ( modify supernodal )
	"

S="${WORKDIR}/${TOPNAME}/${PN^^}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

multilib_src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DENABLE_CUDA=$(usex cuda)
		-DNMATRIXOPS=$(usex matrixops)
		-DNMODIFY=$(usex modify)
		-DNPARTITION=$(usex partition)
		-DNSUPERNODAL=$(usex supernodal)
	)
	cmake_src_configure
}
