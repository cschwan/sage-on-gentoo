# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

MY_PV="${PV}b1"
DESCRIPTION="Custom build of Three.js for SageMath"
HOMEPAGE="https://github.com/sagemath/threejs-sage"
SRC_URI="$(pypi_sdist_url --no-normalize "${PN}" "${MY_PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"
