# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.5

inherit distutils python

DESCRIPTION="A Python package supporting spawning of processes using standard library's threading module"
HOMEPAGE="http://pypi.python.org/pypi/processing"
MY_P="processing-${PV}"
SRC_URI="mirror://berlios/${PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=CHANGES.txt

src_test() {
	# TODO: This should work more easily
	PYTHONPATH="$(ls -d build/lib.*)" "${python}" -c \
		"from processing.tests import main; main()" || die "tests failed"
}
