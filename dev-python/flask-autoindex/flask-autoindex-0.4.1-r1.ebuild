# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A mod_autoindex for Flask"
HOMEPAGE="http://github.com/sublee/flask-autoindex"
SRC_URI="http://github.com/sublee/flask-autoindex/tarball/f903e487faf1969c24d9d14ace366288954c69a0 -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~x86-linux ~amd64-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RDEPEND=">=dev-python/flask-0.8
	dev-python/flask-silk[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
