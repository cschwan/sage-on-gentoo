# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools elisp-common flag-o-matic prefix python-single-r1 versionator

MY_PN=Singular
MY_PV=$(delete_version_separator 3)
# Consistency is different...
MY_DIR2=$(get_version_component_range 1-3 ${PV})
MY_DIR=$(replace_all_version_separators '-' ${MY_DIR2})
# This is where the share tarball unpacks to
MY_SHARE_DIR="${WORKDIR}"/share/

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_URI="http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${PN}-${MY_PV}.tar.gz
		 http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${PN}-${MY_DIR2}-share.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~x86-macos"
IUSE="emacs examples python +readline static-libs"

RDEPEND="dev-libs/gmp:0
	dev-libs/ntl:=
	<dev-libs/ntl-10.0.0
	emacs? ( >=virtual/emacs-22 )
	sci-mathematics/flint
	sci-libs/cddlib
	python? ( ${PYTHON_DEPS} )
	!!sci-libs/libsingular"

DEPEND="${RDEPEND}
	dev-lang/perl
	readline? ( sys-libs/readline )"

SITEFILE=60${PN}-gentoo.el

S="${WORKDIR}/${PN}-${MY_DIR2}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.3-mprimdec.patch
	"${FILESDIR}"/${PN}-4.0.3-xalloc.patch
	"${FILESDIR}"/${PN}-4.0.3-gfan_linking.patch
	)

pkg_setup() {
	append-flags "-fPIC"
	append-ldflags "-fPIC"
	tc-export AR CC CPP CXX

	# Ensure that >=emacs-22 is selected
	if use emacs; then
		elisp-need-emacs 22 || die "Emacs version too low"
	fi

	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf --with-gmp \
		--with-ntl="${EPREFIX}"/usr \
		--with-flint \
		--enable-gfanlib \
		--disable-debug \
		--disable-doc \
		--enable-factory \
		--enable-libfac \
		--enable-IntegerProgramming \
		--disable-polymake \
		$(use_enable static-libs static) \
		$(use_with python) \
		$(use_enable emacs) \
		$(use_with readline)
}

src_compile() {
	default

	if use emacs; then
		pushd "${S}"/emacs
		elisp-compile *.el || die "elisp-compile failed"
		popd
	fi
}

src_install() {
	default

	dosym Singular /usr/bin/"${PN}"
	insinto /usr/share/singular
	doins "${MY_SHARE_DIR}"/info/singular.hlp
}

pkg_postinst() {
	einfo "The authors ask you to register as a SINGULAR user."
	einfo "Please check the license file for details."

	einfo "Additional functionality can be enabled by installing"
	einfo "sci-mathematics/4ti2"

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
