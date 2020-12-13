# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Computing with crystallographic groups"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
GIT_TAG="14c181691192214a20fe4cdfdd520e023fb65793"
SRC_URI="https://github.com/gap-packages/cryst/archive/${GIT_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap-core
	>=dev-gap/polycyclic-2.14"

DOCS="Changelog README.md"

S="${WORKDIR}"/${PN}-${GIT_TAG}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r doc gap grp
	doins *.g
}
