# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_4,3_5} )
inherit distutils-r1

MY_PV="${PV}dev"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="A Python (2 and 3) wrapper for fplll."
HOMEPAGE="https://github.com/fplll/fpylll"
SRC_URI="https://github.com/fplll/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=">=sci-libs/fplll-5.0.0
	dev-python/cython
	dev-python/cysignals
	dev-python/numpy
	test? ( dev-python/pytest )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/PR36.patch
	"${FILESDIR}"/${PN}-0.2.1-sage_no_automagic.patch
	)

S="${WORKDIR}/${MY_P}"

python_test(){
	py.test -v
}
