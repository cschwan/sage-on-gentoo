# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PN="sagenb_export"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="This is a tool to convert SageNB notebooks to other formats."
HOMEPAGE="https://github.com/vbraun/ExportSageNB"
SRC_URI="mirror://sageupstream/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=">=dev-python/ipython-4.0.1[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.1.0[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-install.patch
	)

S="${WORKDIR}/${MY_P}"
