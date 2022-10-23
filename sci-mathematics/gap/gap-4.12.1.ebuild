# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common

DESCRIPTION="System for computational discrete algebra. Core functionality."
HOMEPAGE="https://www.gap-system.org/"
# We need the full release tarball as the core one doesn't include pre-build
# html documentation. Building the html documentation in turns requires GAPDoc to
# be present in the source tree.
SRC_URI="https://github.com/gap-system/gap/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/8"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="cpu_flags_x86_popcnt debug emacs memcheck readline valgrind vim-syntax"
REQUIRED_USE="valgrind? ( memcheck )"

RESTRICT=primaryuri

MINIMUM_PKGS="
	>=dev-gap/GAPDoc-1.6.6
	>=dev-gap/primgrp-3.4.2
	>=dev-gap/SmallGrp-1.5
	>=dev-gap/transgrp-3.6.3"

DEPEND="dev-libs/gmp:=
	sys-libs/zlib
	valgrind? ( dev-util/valgrind )
	readline? ( sys-libs/readline:= )"

RDEPEND="${DEPEND}
	emacs? ( >=app-editors/emacs-23.1:* )
	vim-syntax? ( app-vim/vim-gap )
	!<sci-mathematics/gap-4.12.0
	!sci-mathematics/gap-core"
PDEPEND="${MINIMUM_PKGS}"

REQUIRED_USE="?? ( memcheck valgrind )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.12.0-autoconf.patch
	"${FILESDIR}"/${PN}-4.12.0-no-doc-autoinstall.patch
	"${FILESDIR}"/${PN}-4.12.1-nostrip.patch
)

pkg_setup() {
	if use valgrind; then
		elog "If you enable the use of valgrind duing building"
		elog "be sure that you have enabled the proper flags"
		elog "in gcc to support it:"
		elog "https://wiki.gentoo.org/wiki/Debugging#Valgrind"
	fi
	# make the build/install verbose
	export V=1
}

src_prepare() {
	default

	rm -rf extern
	rm -rf hpcgap/extern
	# use GNUmakefile
	rm Makefile || die
	# Regenerate aclocal from scratch
	rm aclocal.m4 || die

	eautoreconf -f -i
}

src_configure() {
	# Unsetting ABI as gap use the variable internally.
	econf \
		--with-gmp \
		--with-zlib \
		$(use_enable cpu_flags_x86_popcnt popcnt) \
		$(use_enable memcheck memory-checking) \
		$(use_enable valgrind) \
		$(use_with readline) \
		$(use_enable debug) \
		ABI=""
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
