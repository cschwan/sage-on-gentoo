# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="hapcryst"
DESCRIPTION="A HAP extension for crytallographic groups"
HOMEPAGE="https://www.gap-system.org/Packages/hapcryst.html"
SRC_URI="https://github.com/gap-packages/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-core-4.11.0
	>=dev-gap/hap-1.19
	>=dev-gap/polycyclic-2.14
	>=dev-gap/aclib-1.3.1
	>=dev-gap/cryst-4.1.18
	>=dev-gap/polymaking-0.8.2"

DOCS="README CHANGES"

S="${WORKDIR}"/${MY_PN}-${PV}

src_install(){
	default

	insinto /usr/share/gap/pkg/"${MY_PN}-${PV}"
	doins -r doc examples lib
	doins *.g
}
