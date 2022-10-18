# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="This is a tool to convert SageNB notebooks to other formats."
HOMEPAGE="https://github.com/vbraun/ExportSageNB"
SRC_URI="https://github.com/vbraun/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/ipython-4.0.1[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.1.0[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-install.patch
	)

distutils_enable_tests unittest
