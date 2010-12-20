# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="Startup scripts for Sage's Notebook server"
HOMEPAGE="http://sagemath.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sci-mathematics/sage"

pkg_setup() {
	enewgroup sage
	enewuser sage -1 /bin/bash /var/lib/sage sage || die
}

src_prepare() {
	mkdir conf.d || die
	mkdir init.d || die
	cp "${FILESDIR}"/${PN} init.d/${PN} || die "failed to copy file"
	cp "${FILESDIR}"/${PN}.conf conf.d/${PN} || die "failed to copy file"
}

src_install() {
	doinitd init.d/${PN} || die
	doconfd conf.d/${PN} || die
}

pkg_postinst() {
	ewarn "WARNING: The startup script isnt fully tested - use at your own risk"
}
