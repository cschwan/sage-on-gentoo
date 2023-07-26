# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common

DESCRIPTION="System for computational discrete algebra. Core functionality."
HOMEPAGE="https://www.gap-system.org/"
SRC_URI="https://github.com/gap-system/gap/releases/download/v${PV}/${P}-core.tar.gz"

LICENSE="GPL-2+"
SLOT="0/8"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="cpu_flags_x86_popcnt debug emacs memcheck readline valgrind"
REQUIRED_USE="valgrind? ( memcheck )"

MINIMUM_PKGS="
	>=dev-gap/GAPDoc-1.6.6
	>=dev-gap/primgrp-3.4.3
	>=dev-gap/SmallGrp-1.5.1
	>=dev-gap/transgrp-3.6.3"

DEPEND="dev-libs/gmp:=
	sys-libs/zlib
	valgrind? ( dev-util/valgrind )
	readline? ( sys-libs/readline:= )"

RDEPEND="${DEPEND}
	emacs? ( >=app-editors/emacs-23.1:* )
	!<sci-mathematics/gap-4.12.0
	!sci-mathematics/gap-core"
PDEPEND="${MINIMUM_PKGS}"

REQUIRED_USE="?? ( memcheck valgrind )"

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
	# remove some directories so they are not used or explored
	rm -rf extern
	rm -rf hpcgap/extern

	default

	# use GNUmakefile
	rm Makefile || die
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

	# Manually install Makefile.gappkg
	insinto usr/share/gap/etc
	doins etc/Makefile.gappkg

	# la files removal
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
