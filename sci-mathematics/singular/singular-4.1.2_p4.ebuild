# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit autotools elisp-common flag-o-matic prefix python-single-r1

MY_PN=Singular
MY_PV=$(ver_rs 3 '')
# Consistency is different...
MY_DIR2=$(ver_cut 1-3 ${PV})
MY_DIR=$(ver_rs 1- '-' ${MY_DIR2})

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="http://www.singular.uni-kl.de/"
#SRC_URI="http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${PN}-${MY_PV}.tar.gz"
SRC_URI="ftp://jim.mathematik.uni-kl.de/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~x86-macos"
IUSE="emacs examples python +readline static-libs"

RDEPEND="dev-libs/gmp:0
	dev-libs/ntl:=
	emacs? ( >=app-editors/emacs-23.1:* )
	sci-mathematics/flint
	sci-libs/cddlib
	python? ( ${PYTHON_DEPS} )"

DEPEND="${RDEPEND}
	dev-lang/perl
	readline? ( sys-libs/readline )"

SITEFILE=60${PN}-gentoo.el

S="${WORKDIR}/${PN}-${MY_DIR2}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.3-gfan_linking.patch
	"${FILESDIR}"/${PN}-4.1.2_p2-doc_install.patch
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
	# Do not compress ssingular's info file (singular.hlp)
	# some consumer of that file do not know how to deal with compression
	docompress -x /usr/share/info

	default

	dosym Singular /usr/bin/"${PN}"

	# purge .la file
	find "${ED}" -name '*.la' -delete || die
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
