# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A mod_autoindex for Flask"
HOMEPAGE="http://github.com/sublee/flask-autoindex"
SRC_URI="https://github.com/sublee/flask-autoindex/tarball/c60c07b853809ffb2f5e539cc0906f22fbdb0dea -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~x86-linux ~amd64-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RDEPEND=">=dev-python/flask-0.8
	dev-python/flask-silk[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
