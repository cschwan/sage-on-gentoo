# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_{6,7} python3_{2,3} )
inherit distutils-r1

MY_PN="pkgconfig"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="pkgconfig is a Python module to interface with the pkg-config command line tool"
HOMEPAGE="https://github.com/matze/pkgconfig"
SRC_URI="https://github.com/matze/pkgconfig/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x86-macos ~x64-macos"
IUSE="test"

RDEPEND="virtual/pkgconfig"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${MY_P}-setup.patch )

python_test() {
	${EPYTHON} test.py
}
