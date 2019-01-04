# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common

DESCRIPTION="System for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
SRC_URI="https://www.gap-system.org/pub/gap/${PN}-$(ver_cut 1-2)/tar.bz2/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="4.10.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="emacs readline vim-syntax"

RESTRICT="mirror"

DEPEND="dev-libs/gmp:=
	readline? ( sys-libs/readline:= )
	!sci-libs/libgap
	!dev-gap/Alnuth:0
	!dev-gap/GUAVA:0
	!dev-gap/HAPcryst:0
	!dev-gap/aclib:0
	!dev-gap/atlasrep:0
	!dev-gap/autpgrp:0
	!dev-gap/crime:0
	!dev-gap/cryst:0
	!dev-gap/crystcat:0
	!dev-gap/ctbllib:0
	!dev-gap/design:0
	!dev-gap/factint:0
	!dev-gap/grape:0
	!dev-gap/hap:0
	!dev-gap/happrime:0
	!dev-gap/laguna:0
	!dev-gap/polycyclic:0
	!dev-gap/polymaking:0
	!dev-gap/sonata:0
	!dev-gap/tomlib:0
	!dev-gap/toric:0"
RDEPEND="${DEPEND}
	emacs? ( virtual/emacs )
	vim-syntax? ( app-vim/vim-gap )"

PDEPEND="dev-gap/GAPDoc:${SLOT}
	dev-gap/primgrp:${SLOT}
	dev-gap/SmallGrp:${SLOT}
	dev-gap/transgrp:${SLOT}"

PATCHES=(
	"${FILESDIR}"/0001-a-version-of-the-writeandcheck.patch-from-Sage-that-.patch
	"${FILESDIR}"/0002-kernel-add-helper-function-for-writing-error-message.patch
	"${FILESDIR}"/0003-Prototype-for-GAP_Enter-Leave-macros-to-bracket-use-.patch
	"${FILESDIR}"/${PN}-4.10.0-install_config.h.patch
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

src_install(){
	# Create a shell script setting the GAP_ROOT where
	# gap's objects are located
	newbin gap gap-bin
	cat > gap <<-EOF
	#!/bin/env bash
	GAP_ROOT="${EPREFIX}/usr/share/gap/"
	exec gap-bin -l \${GAP_ROOT} -m 64m "\$@"
	EOF
	default

	# install the objects needed for gap to work
	# Some like GAPDoc can be installed as PDEPEND
	insinto /usr/share/gap/
	doins -r doc grp lib
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
