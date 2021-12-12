# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="primecount is a CLI and library that counts the primes below an integer x<10^31"
HOMEPAGE="https://github.com/kimwalisch/primecount"
SRC_URI="https://github.com/kimwalisch/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0/7"
KEYWORDS="~amd64"
IUSE="test openmp"
RESTRICT="!test? ( test )"

RDEPEND=">=sci-mathematics/primesieve-7.6"
DEPEND="${RDEPEND}"

pkg_pretend() {
	use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS="$(usex test)"
		-DBUILD_LIBPRIMESIEVE="OFF"
		-DBUILD_STATIC_LIBS="OFF"
		-DWITH_OPENMP="$(usex openmp)"
	)

	cmake_src_configure
}
