# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common

DESCRIPTION="System for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
#SRC_URI="https://www.gap-system.org/pub/gap/${PN}-$(ver_cut 1-2)/tar.bz2/${P}.tar.bz2"
SRC_URI="https://github.com/gap-system/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="emacs readline +recommended_pkgs vim-syntax"

RESTRICT="mirror"

MINIMUM_PKGS="
	~dev-gap/GAPDoc-1.6.2
	~dev-gap/primgrp-3.3.2
	~dev-gap/SmallGrp-1.3
	~dev-gap/transgrp-2.0.4"

RECOMMENDED_PKGS="
	>=dev-gap/autpgrp-1.10
	>=dev-gap/Alnuth-3.1.1
	>=dev-gap/crisp-1.4.4
	>=dev-gap/ctbllib-1.2_p2
	>=dev-gap/factint-1.6.2
	>=dev-gap/fga-1.4.0
	>=dev-gap/irredsol-1.4
	>=dev-gap/laguna-3.9.3
	>=dev-gap/polenta-1.3.8
	>=dev-gap/polycyclic-2.14
	>=dev-gap/resclasses-4.7.2
	>=dev-gap/sophus-1.24
	>=dev-gap/tomlib-1.2.8"

DEPEND="dev-libs/gmp:=
	readline? ( sys-libs/readline:= )
	!!sci-libs/libgap"
RDEPEND="${DEPEND}
	emacs? ( >=app-editors/emacs-23.1:* )
	vim-syntax? ( app-vim/vim-gap )"
PDEPEND="${MINIMUM_PKGS}
	recommended_pkgs? ( ${RECOMMENDED_PKGS} )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.10.1-install.patch
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
	# Load sysinfo.gap to access its content
	source sysinfo.gap
	# Install the real binary in GAP_ROOT/bin/GAParch
	exeinto /usr/share/gap/bin/${GAParch}
	doexe gap
	# Create a shell script setting the GAP_ROOT where
	# gap's objects are located
	cat > gap <<-EOF
	#!${EPREFIX}/bin/bash
	exec ${EPREFIX}/usr/share/gap/bin/${GAParch}/gap -m 64m "\$@"
	EOF
	default

	# install the objects needed for gap to work
	# Some like GAPDoc can be installed as RDEPEND
	insinto /usr/share/gap/
	doins -r doc grp lib
	# Some packages still need sysinfo.gap (guava)
	# some of the content is currently silly but harmless
	doins sysinfo.gap
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
