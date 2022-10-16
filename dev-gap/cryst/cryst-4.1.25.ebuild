# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Computing with crystallographic groups"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
SLOT="0"
GIT_TAG="dd6c82a292a23c0f70f79a9b2ae8d9299c1efad5"
SRC_URI="https://github.com/gap-packages/cryst/archive/${GIT_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/polycyclic-2.16"

DOCS="Changelog README.md"

S="${WORKDIR}"/${PN}-${GIT_TAG}

GAP_PKG_OBJS="doc gap grp"
