# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION="${PV}"
SAGE_PACKAGE="examples-${PV}"

inherit sage

DESCRIPTION="Sage examples"
# HOMEPAGE=""
# SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	# remove mecurial directories
	hg_clean

	# is test_all needed ?
	rm sage-push spkg-install test_all
}

src_install() {
	insinto "${SAGE_ROOT}"/examples
	doins -r *
}
