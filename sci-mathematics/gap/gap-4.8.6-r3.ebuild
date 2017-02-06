# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools elisp-common

# gap-lite is a pre-made tarball where the following has been removed:
# 1) all pkg
# 2) content of the bin folder - premade stuff
# 3) gmp tarball(s) in the extern folder (don't remove the makefile)
# sage also remove some of the database
MY_P="gap-lite-${PV}"
DESCRIPTION="System for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
SRC_URI="mirror://sagemath/${MY_P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="emacs readline vim-syntax"

RESTRICT="mirror"

DEPEND="dev-libs/gmp:=
	readline? ( sys-libs/readline:= )"
RDEPEND="${DEPEND}
	emacs? ( virtual/emacs )
	vim-syntax? ( app-vim/vim-gap )"

PDEPEND="dev-gap/GAPDoc"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.7-writeandcheck.patch
	"${FILESDIR}"/${PN}-4.8.6-configdir.patch
	"${FILESDIR}"/${PN}-4.8.6-no_default_package.patch
	)

src_prepare(){
	default

	eautoreconf
	pushd cnf
	eautoreconf
	mv configure configure.out || die "failed to move configure in cnf"
	popd
}

src_configure(){
	econf \
		--with-gmp=system \
		$(use_with readline) \
		ABI=""

	emake config ABI=""
}

src_install(){
	insinto /usr/$(get_libdir)/${PN}
	# This is excrutiatingly slow even with the reduced content.
	# An install target in the makefile may speed things up.
	doins -r doc \
		grp \
		lib \
		prim \
		small \
		trans \
		tst \
		sysinfo.gap*

	insinto /usr/$(get_libdir)/${PN}/bin
	doins bin/gap.sh bin/gap-*

	source sysinfo.gap
	pushd bin/${GAParch_system}
	# replace the objects needed in gac by an archive.
	# compstat.o is explicitely excluded from it.
	rm -f compstat.o
	ar qv libgap.a *.o || die "failed to produce the libgap archive"
	insinto /usr/$(get_libdir)/${PN}/bin/${GAParch_system}
	doins gap \
		libgap.a
	popd

	newbin bin/gap.sh gap
	newbin bin/${GAParch_system}/gac gac

	dosym /usr/$(get_libdir)/${PN}/sysinfo.gap /etc/sysinfo.gap

	# install the header in 'gap-system'
	# libgap installs its header into 'gap' and they would collide
	insinto /usr/include/gap-system
	doins src/*.h

	dodoc CITATION CONTRIBUTING.md README.md

	# Make the real gap program executable again after install
	einfo "making /usr/$(get_libdir)/${PN}/bin/${GAParch_system}/gap executable"
	fperms 755 /usr/$(get_libdir)/${PN}/bin/${GAParch_system}/gap
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
