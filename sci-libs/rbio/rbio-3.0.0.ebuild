# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_PV="6.0.0-beta7"
TOPNAME="SuiteSparse-${MY_PV}"
DESCRIPTION="Common configurations for all packages in suitesparse"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${MY_PV}.tar.gz -> ${TOPNAME}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="~sci-libs/suitesparseconfig-6.0.0_beta7"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${TOPNAME}/RBio"

multilib_src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	# Run demo files
	./RBdemo < "${S}"/RBio/private/west0479.rua
}
