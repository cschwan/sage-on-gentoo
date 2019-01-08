# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common

DESCRIPTION="System for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
SRC_URI="https://www.gap-system.org/pub/gap/gap48/tar.bz2/gap4r8p6_2016_11_12-14_25.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/4.8.6"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="emacs readline vim-syntax"

RESTRICT="mirror"

DEPEND="dev-libs/gmp:=
	readline? ( sys-libs/readline:= )"
RDEPEND="${DEPEND}
	dev-gap/GAPDoc:${SLOT}
	emacs? ( virtual/emacs )
	vim-syntax? ( app-vim/vim-gap )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5.7-writeandcheck.patch
	"${FILESDIR}"/${PN}-4.8.6-configdir.patch
	"${FILESDIR}"/${PN}-4.8.6-no_default_package.patch
	)

S="${WORKDIR}"/${PN}$(ver_cut 1)r$(ver_cut 2)

src_prepare(){
	rm -rf pkg
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

	dosym ../usr/$(get_libdir)/${PN}/sysinfo.gap /etc/sysinfo.gap

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
