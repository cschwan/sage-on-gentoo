# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GAP Transitive Groups Library"
HOMEPAGE="https://www.gap-system.org/Packages/transgrp.html"
SLOT="0"
SRC_URI="https://www.math.colostate.edu/~hulpke/${PN}/${PN}${PV}.tar.gz"

# Data format is licensed Artistic-2
# Code is licensed GPL-3
LICENSE="GPL-3
	Artistic-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( >=sci-mathematics/gap-core-4.11.1 >=sci-mathematics/gap-4.11.1 )"

HTML_DOCS=htm/*
DOCS="README.md LICENSE"

S="${WORKDIR}"/${PN}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r data doc lib
	doins *.g
}
