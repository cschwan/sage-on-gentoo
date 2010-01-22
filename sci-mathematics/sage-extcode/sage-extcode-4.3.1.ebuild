# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SAGE_VERSION=${PV}
SAGE_PACKAGE=extcode-${PV}

inherit sage

DESCRIPTION="Data for Sage"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

# TODO: check contents of extcode, e.g. contains jsmath!
src_install() {
	insinto "${SAGE_DATA}"/extcode

	rm -r .hg mirror sage-push spkg-debian spkg-dist spkg-install \
		|| die "rm failed"

	doins -r * || die "doins failed"
}
