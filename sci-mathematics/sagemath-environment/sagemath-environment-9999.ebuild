# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3 sage-git
else
	PYPI_NO_NORMALIZE=1
	inherit pypi
	KEYWORDS="~amd64 ~amd64-linux ~ppc-macos ~x64-macos"
fi

DESCRIPTION="basic sagemath environment"
HOMEPAGE="https://www.sagemath.org"

LICENSE="GPL-2+"
SLOT="0"

RESTRICT="test"

RDEPEND="${DEPEND}"

python_install() {
	distutils-r1_python_install

	find "${D}$(python_get_sitedir)/sage" -name interpreter -delete
}
