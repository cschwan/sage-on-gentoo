# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GAP Transitive Groups Library"
HOMEPAGE="https://www.gap-system.org/Packages/transgrp.html"
GAP_VERSION="4.10.2"
SLOT="0/${GAP_VERSION}"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${GAP_VERSION})/tar.bz2/gap-${GAP_VERSION}.tar.bz2"

# Data format is licensed Artistic-2
# Code is licensed GPL-3
LICENSE="GPL-3
	Artistic-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}"

HTML_DOCS=htm/*
DOCS="README.txt LICENSE"

S="${WORKDIR}/gap-${GAP_VERSION}/pkg/${PN}"

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r data doc lib
	doins *.g
}
