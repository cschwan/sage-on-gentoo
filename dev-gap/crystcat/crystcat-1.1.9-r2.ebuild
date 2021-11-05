# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The crystallographic groups catalog"
HOMEPAGE="https://www.gap-system.org/Packages/${PN}.html"
GIT_TAG="13964998becf4ba9f3e4befdfb16fb50a1293094"
SLOT="0"
SRC_URI="https://github.com/gap-packages/crystcat/archive/${GIT_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sci-mathematics/gap-core-4.11.0
	>=dev-gap/cryst-4.1.23"

S="${WORKDIR}/${PN}-${GIT_TAG}"

DOCS="Changelog README"

src_install() {
	default

	insinto /usr/share/gap/pkg/"${PN}"
	doins -r doc grp lib
	doins *.g
}
