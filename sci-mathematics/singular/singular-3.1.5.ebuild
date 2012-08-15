# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/singular/singular-3.1.4-r1.ebuild,v 1.4 2012/06/23 10:50:20 xarthisius Exp $

EAPI="3"
#WANT_AUTOCONF="2.1" # Upstream ticket 240 -> wontfix

PYTHON_DEPEND="python? 2"

# Upstream does not care about tests.
RESTRICT="test"

inherit autotools eutils elisp-common flag-o-matic multilib prefix python versionator

MY_PN=Singular
MY_PV=$(replace_all_version_separators -)
MY_DIR=$(get_version_component_range 1-3 ${MY_PV})
# There 'share' tarball does not get updated on every release
MY_SHARE_DIR="3-1-5"
MY_PV_SHARE="${MY_PV}"

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_COM="http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/"
# Share stuff did not see a new version:
SRC_URI="${SRC_COM}${MY_DIR}/${MY_PN}-${MY_PV}.tar.gz
		 ${SRC_COM}${MY_SHARE_DIR}/Singular-${MY_PV_SHARE}-share.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="boost doc emacs examples python +readline test"

RDEPEND="dev-libs/gmp
	>=dev-libs/ntl-5.5.1
	emacs? ( >=virtual/emacs-22 )"

DEPEND="${RDEPEND}
	dev-lang/perl
	boost? ( dev-libs/boost )
	readline? ( sys-libs/readline )"

S="${WORKDIR}"/${MY_PN}-${MY_DIR}
SITEFILE=60${PN}-gentoo.el

pkg_setup() {
	append-flags "-fPIC"
	append-ldflags "-fPIC"
	tc-export CC CPP CXX

	# Ensure that >=emacs-22 is selected
	if use emacs; then
		elisp-need-emacs 22 || die "Emacs version too low"
	fi

	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare () {
	epatch "${FILESDIR}"/${PN}-3.1.0-gentoo.patch
	epatch "${FILESDIR}"/${PN}-3.1.0-emacs-22.patch
	epatch "${FILESDIR}"/${PN}-3.0.4.4-nostrip.patch
	epatch "${FILESDIR}"/${PN}-3.1.3.3-Minor.h.patch
	epatch "${FILESDIR}"/${PN}-3.1.5-NTLnegate.patch
	epatch "${FILESDIR}"/${PN}_trac_439.patch
	epatch "${FILESDIR}"/${PN}_trac_440.patch
	epatch "${FILESDIR}"/${PN}_trac_441.patch
	epatch "${FILESDIR}"/${PN}_trac_443.patch

	use python && epatch "${FILESDIR}"/${PN}-3.1.3.2-python.patch

	if  [[ ${CHOST} == *-darwin* ]] ; then
		epatch "${FILESDIR}"/${PN}-3.1.3.3-install_name.patch
		eprefixify kernel/Makefile.in
		eprefixify Singular/Makefile.in
	fi

	eprefixify kernel/feResource.cc

	# The SLDFLAGS mangling prevents passing raw LDLAGS to gcc (see e.g. bug 414709)
	sed -i \
		-e "/CXXFLAGS/ s/--no-exceptions//g" \
		-e "s/SLDFLAGS=-shared/SLDFLAGS=\"$(raw-ldflags) -shared\"\n\t  \tSLDFLAGS2=\"${LDFLAGS} -shared\"/" \
		-e "s/  SLDFLAGS=/  SLDFLAGS=\n  SLDFLAGS2=/" \
		-e "s/AC_SUBST(SLDFLAGS)/AC_SUBST(SLDFLAGS)\nAC_SUBST(SLDFLAGS2)/" \
		"${S}"/Singular/configure.in || die

	sed -i \
		-e "s/@SLDFLAGS@/@SLDFLAGS@\nSLDFLAGS2\t= @SLDFLAGS2@/" \
		-e "/\$(CXX).*SLDFLAGS/s/SLDFLAGS/SLDFLAGS2/" \
		"${S}"/Singular/Makefile.in || die

	# remove ntl sources for safety.
	rm -rf ntl

	cd "${S}"/Singular || die "failed to cd into Singular/"

	eautoconf
}

src_configure() {

	econf \
		--prefix="${S}"/build \
		--exec-prefix="${S}"/build \
		--bindir="${S}"/build/bin \
		--libdir="${S}"/build/lib \
		--libexecdir="${S}"/build/lib \
		--includedir="${S}"/build/include \
		--with-apint=gmp \
		--with-NTL \
		--disable-doc \
		--without-MP \
		--without-flint \
		--enable-factory \
		--enable-libfac \
		--enable-IntegerProgramming \
		--enable-Singular \
		--with-malloc=system \
		$(use_with python python embed) \
		$(use_with boost Boost) \
		$(use_enable emacs) \
		$(use_with readline) || die "configure failed"
}

src_compile() {
	emake || die "emake failed"

	if use emacs; then
		cd "${WORKDIR}"/${MY_PN}/${MY_SHARE_DIR}/emacs/
		elisp-compile *.el || die "elisp-compile failed"
	fi
}

src_test() {
	# Tests fail to link -lsingular, upstream ticket #243
	emake test || die "tests failed"
}

src_install () {
	dodoc README
	# execs and libraries
	cd "${S}"/build/bin
	dobin ${MY_PN}* gen_test change_cost solve_IP toric_ideal LLL \
		|| die "failed to install binaries"
	insinto /usr/$(get_libdir)/${PN}
	doins *.so || die "failed to install libraries"

	dosym ${MY_PN}-${MY_DIR} /usr/bin/${MY_PN} \
		|| die "failed to create symbolic link"

	# stuff from the share tar ball
	cd "${WORKDIR}"/${MY_PN}/${MY_SHARE_DIR}
	insinto /usr/share/${PN}
	doins -r LIB  || die "failed to install lib files"
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "failed to install examples"
	fi
	if use doc; then
		dohtml -r html/* || die "failed to install html docs"
		insinto /usr/share/${PN}
		doins doc/singular.idx || die "failed to install idx file"
		cp info/${PN}.hlp info/${PN}.info &&
		doinfo info/${PN}.info \
			|| die "failed to install info files"
	fi
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
