# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A Computer algebra package for Lie group computations"
HOMEPAGE="http://www-math.univ-poitiers.fr/~maavl/LiE/"
SRC_URI="http://www-math.univ-poitiers.fr/~maavl/LiE/conLiE.tar.gz -> ${P}.tar.gz"
#### Remove the following line when moving this ebuild to the main tree!
LICENSE="LGPL-2.1"
##### See https://packages.debian.org/changelogs/pool/main/l/lie/lie_2.2.2+dfsg-1/lie.copyright
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	sys-devel/bison
	sys-libs/readline:0=
	sys-libs/ncurses:0="
RDEPEND="sys-libs/readline:=
	sys-libs/ncurses"

S="${WORKDIR}/LiE"
DOCS=( "README" )

PATCHES=(
	"${FILESDIR}"/${P}-make.patch
	)

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	use doc && DOCS+=( "${S}"/manual/* )
	default
}
