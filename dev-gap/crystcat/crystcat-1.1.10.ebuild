# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="The crystallographic groups catalog"
HOMEPAGE="https://www.gap-system.org/Packages/crystcat.html"
GIT_TAG="dc84e1a8bac2ae613ba321b8247ebeee6defaa28"
SLOT="0"
SRC_URI="https://github.com/gap-packages/crystcat/archive/${GIT_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-4.12.0
	>=dev-gap/cryst-4.1.25"

S="${WORKDIR}/${PN}-${GIT_TAG}"

DOCS="Changelog README"

GAP_PKG_OBJS="doc grp lib"
