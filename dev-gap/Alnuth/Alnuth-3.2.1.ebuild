# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

MY_P="alnuth-${PV}"
DESCRIPTION="Algebraic number theory and an interface to PARI/GP"
HOMEPAGE="https://www.gap-system.org/Packages/alnuth.html"
SLOT="0"
SRC_URI="https://github.com/gap-packages/alnuth/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS="CHANGES.md README.md"
HTML_DOCS=htm/*

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=sci-mathematics/pari-2.5.0
	>=dev-gap/polycyclic-2.16"

GAP_PKG_OBJS="doc exam gap gp"

S="${WORKDIR}/${MY_P}"
