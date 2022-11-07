# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_PV=$(ver_rs 3 '-')
TOPNAME="SuiteSparse-${MY_PV}"
DESCRIPTION="Common configurations for all packages in suitesparse"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${MY_PV}.tar.gz -> ${TOPNAME}.gh.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="~sci-libs/suitesparseconfig-${PV}
	~sci-libs/amd-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${TOPNAME}/${PN^^}"

multilib_src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
	)
	cmake_src_configure
}
