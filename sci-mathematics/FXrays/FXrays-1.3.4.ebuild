# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Finding extremal rays of a polyhedral cone"
HOMEPAGE="https://github.com/3-manifolds/FXrays
	https://pypi.org/project/FXrays/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
