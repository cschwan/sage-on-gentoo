# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils

DESCRIPTION="Startup scripts for Sage's Notebook server"
HOMEPAGE="http://sagemath.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sci-mathematics/sage-notebook"

S="${WORKDIR}"

pkg_setup() {
	enewgroup sage
	enewuser sage -1 /bin/bash /var/lib/sage sage
}

src_prepare() {
	mkdir conf.d || die "failed to create directory"
	mkdir init.d || die "failed to create directory"
	cp "${FILESDIR}"/${PN} init.d/${PN} || die "failed to copy file"
	cp "${FILESDIR}"/${PN}.conf conf.d/${PN} || die "failed to copy file"
}

src_install() {
	doinitd init.d/${PN}
	doconfd conf.d/${PN}
}
