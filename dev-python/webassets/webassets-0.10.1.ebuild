# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_3 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Merges, minifies and compresses Javascript and CSS files"
HOMEPAGE="http://github.com/miracle2k/webassets/"
SRC_URI="https://github.com/miracle2k/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~x86-linux ~amd64-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE=""

RDEPEND=""
DEPEND="dev-python/sphinx"
