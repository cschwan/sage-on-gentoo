# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/singular/singular-3.1.0.7.ebuild,v 1.1 2009/11/24 03:38:03 markusle Exp $

EAPI="2"

inherit eutils elisp-common flag-o-matic autotools multilib versionator

PV_MAJOR=${PV%.*}
MY_PV=${PV//./-}
MY_PN=${PN/s/S}
MY_PV_MAJOR=${MY_PV%-*}
MY_SHARE="3-1-0-4"

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_URI="http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/${MY_PV_MAJOR}/${MY_PN}-${MY_PV}.tar.gz
	http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/UNIX/${MY_PN}-${MY_SHARE}-share.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost doc emacs examples"

RDEPEND=">=dev-libs/gmp-4.1-r1
		>=dev-libs/ntl-5.5.1
		emacs? ( >=virtual/emacs-22 )"

DEPEND="${RDEPEND}
		>=dev-lang/perl-5.6
		boost? ( dev-libs/boost )"

S="${WORKDIR}"/${MY_PN}-${MY_PV_MAJOR}
SITEFILE=60${PN}-gentoo.el

src_prepare () {
	epatch "${FILESDIR}"/${PN}-${PV_MAJOR}-gentoo.patch
	epatch "${FILESDIR}"/${PN}-3.0.4.4-nostrip.patch
	epatch "${FILESDIR}"/${PN}-${PV_MAJOR}-emacs-22.patch
	epatch "${FILESDIR}"/${PN}-${PV_MAJOR}-glibc-2.10.patch

	sed -e "s/PFSUBST/${PF}/" -i kernel/feResource.cc \
		|| die "sed failed on feResource.cc"

	cd "${S}"/Singular || die "failed to cd into Singular/"

	if use boost; then
		sed -e "/CXXFLAGS/ s/--no-exceptions//g" \
			-i configure.in \
			|| die "failed to fix --no-exceptions for boost"
	fi
	eautoconf
}

src_configure() {
	local myconf="$(use_with boost Boost) \
				$(use_enable emacs) \
				--disable-doc \
				--without-MP \
				--with-factory \
				--with-libfac \
				--disable-NTL \
				--disable-gmp \
				--prefix=${S}"

	econf ${myconf} || die "econf failed"
}

src_compile() {
	emake -j1 || die "make failed"
	emake -j1 libsingular || "emake failed"

	if use emacs; then
		cd "${WORKDIR}"/${MY_PN}/${MY_PV_MAJOR}/emacs/
		elisp-compile *.el || die "elisp-compile failed"
	fi
}

src_install () {
	# install headers and library for libsingular
	emake -j1 DESTDIR="${D}" install-libsingular || die "emake install failed"
	insinto /usr/include
	cd "${S}"/*-Linux/include && doins -r cf_gmp.h factory.h factoryconf.h \
    	mylimits.h libsingular.h singular \
		|| die "installation of headers failed"
	dodir /usr/include/templates || die "failed to make templates directory"
	insinto /usr/include/templates
	cd "${S}"/*-Linux/include/templates && doins *.h \
		|| die "failed to install template headers"
	cd "${S}"/*-Linux/lib && dolib.so libsingular.so \
		|| die "installation of libraries failed"

	# install basic docs
	cd "${S}" && dodoc BUGS ChangeLog || \
		die "failed to install docs"

	# install data files
	insinto /usr/share/${PN}/LIB
	cd "${S}"/${MY_PN}/LIB && doins *.lib help.cnf \
		|| die "failed to install lib files"
	insinto /usr/share/${PN}/LIB/gftables
	cd gftables && doins * \
		|| die "failed to install files int LIB/gftables"

	cd "${S}"/*-Linux

	# install binaries
	rm ${MY_PN} || die "failed to remove ${MY_PN}"
	dobin ${MY_PN}* gen_test change_cost solve_IP toric_ideal LLL \
		|| die "failed to install binaries"

	# install libraries
	insinto /usr/$(get_libdir)/${PN}
	doins *.so || die "failed to install libraries"

	# create symbolic link
	dosym /usr/bin/${MY_PN}-${MY_PV_MAJOR} /usr/bin/${MY_PN} \
		|| die "failed to create symbolic link"

	cd "${WORKDIR}"/${MY_PN}/${MY_PV_MAJOR}

	# install examples
	if use examples; then
		insinto /usr/share/${PN}/examples
		doins examples/* || die "failed to install examples"
	fi

	# install extended docs
	if use doc; then
		dohtml -r html/* || die "failed to install html docs"

		insinto /usr/share/${PN}
		doins doc/singular.idx || die "failed to install idx file"

		cp info/${PN}.hlp info/${PN}.info &&
		doinfo info/${PN}.info \
			|| die "failed to install info files"
	fi

	# install emacs specific stuff here, as we did a directory change
	# some lines above!
	if use emacs; then
		elisp-install ${PN} emacs/*.el emacs/*.elc emacs/.emacs* \
			|| die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	einfo "The authors ask you to register as a SINGULAR user."
	einfo "Please check the license file for details."

	if use emacs; then
		echo
		ewarn "Please note that the ESingular emacs wrapper has been"
		ewarn "removed in favor of full fledged singular support within"
		ewarn "Gentoo's emacs infrastructure; i.e. just fire up emacs"
		ewarn "and you should be good to go! See bug #193411 for more info."
		echo
	fi

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
