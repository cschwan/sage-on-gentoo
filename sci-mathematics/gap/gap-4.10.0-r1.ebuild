# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common

DESCRIPTION="System for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
SRC_URI="https://www.gap-system.org/pub/gap/${PN}-$(ver_cut 1-2)/tar.bz2/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="emacs readline vim-syntax"

RESTRICT="mirror"

DEPEND="dev-libs/gmp:=
	readline? ( sys-libs/readline:= )
	!sci-libs/libgap"
RDEPEND="${DEPEND}
	emacs? ( virtual/emacs )
	vim-syntax? ( app-vim/vim-gap )"

PATCHES=(
	"${FILESDIR}"/0001-a-version-of-the-writeandcheck.patch-from-Sage-that-.patch
	"${FILESDIR}"/0002-kernel-add-helper-function-for-writing-error-message.patch
	"${FILESDIR}"/0003-Prototype-for-GAP_Enter-Leave-macros-to-bracket-use-.patch
	)

pkg_setup(){
	# make the build/install verbose
	export V=1
}

src_prepare(){
	default

	rm -rf extern
	rm -rf hpcgap/extern
}

src_configure(){
	# Unsetting ABI as gap use the variable internally.
	econf \
		$(use_with readline) \
		ABI=""
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
