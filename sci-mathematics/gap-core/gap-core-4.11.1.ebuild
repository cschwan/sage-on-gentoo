# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common

MY_P="gap-${PV}"
DESCRIPTION="System for computational discrete algebra. Core functionality."
HOMEPAGE="https://www.gap-system.org/"
# We need the full release tarball as the core one doesn't include pre-build
# html documentation. Building the html documentation in turns requires GAPDoc to
# be present in the source tree.
SRC_URI="https://github.com/gap-system/gap/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug emacs memcheck readline valgrind vim-syntax"
REQUIRED_USE="valgrind? ( memcheck )"

RESTRICT=primaryuri

MINIMUM_PKGS="
	>=dev-gap/GAPDoc-1.6.4
	>=dev-gap/primgrp-3.4.1
	>=dev-gap/SmallGrp-1.4.1
	>=dev-gap/transgrp-2.0.5"

# The following packages are slotted with 0/4.10.2 and need unmerging first.
# Slot blockers for earlier version of gap are not considered.
SLOT_BLOCKERS="
	!!<=dev-gap/atlasrep-2.1_p0
	!!<=dev-gap/crisp-1.4.4-r2
	!!<=dev-gap/cryst-4.1.19
	!!<=dev-gap/hap-1.19-r1
	!!<=dev-gap/irredsol-1.4-r2
	!!<=dev-gap/transgrp-2.0.4-r2"

DEPEND="dev-libs/gmp:=
	sys-libs/zlib
	valgrind? ( dev-util/valgrind )
	readline? ( sys-libs/readline:= )
	${SLOT_BLOCKERS}"
RDEPEND="${DEPEND}
	emacs? ( >=app-editors/emacs-23.1:* )
	vim-syntax? ( app-vim/vim-gap )
	!<sci-mathematics/gap-4.11.0"
PDEPEND="${MINIMUM_PKGS}"

REQUIRED_USE="?? ( memcheck valgrind )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.11.1-install.patch
	"${FILESDIR}"/${PN}-4.11.1-autoconf.patch
	"${FILESDIR}"/${PN}-4.11.1-gac.patch
	"${FILESDIR}"/${PN}-4.11.1-pkgbuild.patch
)

S="${WORKDIR}/${MY_P}"

pkg_setup(){
	if use valgrind; then
		elog "If you enable the use of valgrind duing building"
		elog "be sure that you have enabled the proper flags"
		elog "in gcc to support it:"
		elog "https://wiki.gentoo.org/wiki/Debugging#Valgrind"
	fi
	# make the build/install verbose
	export V=1
}

src_prepare(){
	default

	rm -rf extern
	rm -rf hpcgap/extern
	# use GNUmakefile
	rm Makefile || die
	# Regenerate aclocal from scratch
	rm aclocal.m4 || die

	eautoreconf -f -i
}

src_configure(){
	# Unsetting ABI as gap use the variable internally.
	econf \
		--with-gmp \
		--with-zlib \
		--enable-popcnt \
		$(use_enable memcheck memory-checking) \
		$(use_enable valgrind) \
		$(use_with readline) \
		$(use_enable debug) \
		ABI=""
}

src_install(){
	# Load sysinfo.gap to access its content
	source sysinfo.gap
	# Install the real binary in GAP_ROOT/bin/GAParch
	exeinto /usr/share/gap/bin/${GAParch}
	doexe gap
	# install gap's libtool for gac
	exeinto /usr/share/gap
	doexe libtool
	# Create a shell script setting the GAP_ROOT where
	# gap's objects are located
	cat > gap <<-EOF
	#!${EPREFIX}/bin/bash
	exec ${EPREFIX}/usr/share/gap/bin/${GAParch}/gap -m 64m "\$@"
	EOF
	# Install target for binaries is currently broken
	dobin gap
	dobin gac
	default

	# install the objects needed for gap to work
	# Some like GAPDoc can be installed as RDEPEND
	insinto /usr/share/gap/
	doins -r doc grp lib
	# install extra object for building some packages
	insinto /usr/share/gap/etc/
	doins etc/Makefile.gappkg
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
