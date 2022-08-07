# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A free LDL factorisation routine for quasi-definite linear systems"
HOMEPAGE="https://github.com/osqp/qdldl"
SRC_URI="https://github.com/osqp/qdldl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test static-libs"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( static-libs )"

DEPEND=""

src_configure() {
	local mycmakeargs=(
		-DQDLDL_BUILD_STATIC_LIB=$(usex static-libs)
		-DQDLDL_UNITTESTS=$(usex test)
	)
	cmake_src_configure
}
