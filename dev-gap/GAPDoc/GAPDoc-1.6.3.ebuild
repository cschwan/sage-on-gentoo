# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Meta Package for GAP Documentation"
HOMEPAGE="https://www.gap-system.org/Packages/gapdoc.html"
SLOT="0"
SRC_URI="https://github.com/frankluebeck/${PN}/archive/relv${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-mathematics/gap-4.10.1"

DOCS="CHANGES README.md"

S="${WORKDIR}"/${PN}-relv${PV}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${P}"
	doins -r 3k+1 doc example lib styles
	doins *.g *.dtd version
}
