# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )
inherit distutils-r1

DESCRIPTION="A Python interface to the number theory library libpari"
HOMEPAGE="https://github.com/defeo/cypari2"
SRC_URI="http://sage.ugent.be/www/jdemeyer/sage/cypari2-1.0.0.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sci-mathematics/pari-2.9.0
	dev-python/cython
	dev-python/cysignals"
RDEPEND="${DEPEND}"
