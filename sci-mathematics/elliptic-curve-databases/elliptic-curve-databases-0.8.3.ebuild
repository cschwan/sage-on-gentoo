# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 pypi

DESCRIPTION="two small, read-only elliptic-curve databases"
HOMEPAGE="https://pypi.org/project/elliptic-curve-databases/
	https://github.com/sagemath/data-elliptic-curves"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests pytest
