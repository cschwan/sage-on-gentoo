# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

MY_PN="hapcryst"
DESCRIPTION="A HAP extension for crytallographic groups"
HOMEPAGE="https://www.gap-system.org/Packages/hapcryst.html"
SRC_URI="https://github.com/gap-packages/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/hap-1.47
	>=dev-gap/polycyclic-2.16
	>=dev-gap/aclib-1.3.2
	>=dev-gap/cryst-4.1.25
	>=dev-gap/polymaking-0.8.6"

DOCS="README CHANGES"

GAP_PKG_OBJS="doc examples lib"

S="${WORKDIR}"/${MY_PN}-${PV}
