# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/pari/pari-2.3.4-r1.ebuild,v 1.9 2010/01/11 22:38:57 jer Exp $

EAPI=2
inherit elisp-common eutils flag-o-matic toolchain-funcs

DESCRIPTION="A software package for computer-aided number theory"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"

SRC_COM="http://pari.math.u-bordeaux.fr/pub/${PN}"
SRC_URI="${SRC_COM}/unix/${P}.tar.gz
	data? (	${SRC_COM}/packages/elldata.tgz
			${SRC_COM}/packages/galdata.tgz
			${SRC_COM}/packages/seadata.tgz
			${SRC_COM}/packages/nftables.tgz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc data emacs fltk gmp mpir static X"

RDEPEND="sys-libs/readline
	emacs? ( virtual/emacs )
	fltk? ( x11-libs/fltk )
	gmp? ( dev-libs/gmp )
	mpir? ( sci-libs/mpir )
	X? ( x11-libs/libX11 )
	doc? ( X? ( x11-misc/xdg-utils ) )"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

SITEFILE=50${PN}-gentoo.el

get_compile_dir() {
	pushd "${S}/config" >& /dev/null
	local fastread=yes
	source ./get_archos
	popd >& /dev/null
	echo "O${osname}-${arch}"
}

pkg_setup() {
	if( use gmp && use mpir ); then
		einfo "gmp and mpir use flags are mutually exclusise."
		einfo "please choose only one."
		die
	fi
}

src_prepare() {
	# move data into place
	if use data; then
		mv "${WORKDIR}"/data "${S}" || die "failed to move data"
	fi
	epatch "${FILESDIR}/${PN}"-2.3.2-strip.patch
	epatch "${FILESDIR}/${PN}"-2.3.2-ppc-powerpc-arch-fix.patch
	# Patch doc makefile for parallel make.
	epatch "${FILESDIR}/${PN}"-2.3.5-DOC_MAKE.patch
	epatch "${FILESDIR}/${PN}"-2.3.4-mpir.patch
	cp "${FILESDIR}/get_mpir" "${S}/config"
	cp "${FILESDIR}/mpir_version.c" "${S}/config"

	# disable default building of docs during install
	sed -i \
		-e "s:install-doc install-examples:install-examples:" \
		config/Makefile.SH || die "Failed to fix makefile"
	# propagate ldflags
	sed -i \
		-e 's/-shared $extra/-shared $extra \\$(LDFLAGS)/' \
		config/get_dlld || die "Failed to fix LDFLAGS"
	# move doc dir to a gentoo doc dir and replace hardcoded xdvi by xdg-open
	sed -i \
		-e "s:\$d = \$0:\$d = '/usr/share/doc/${PF}':" \
		-e 's:"acroread":"xdg-open":' \
		doc/gphelp.in || die "Failed to fix doc dir"
}

src_configure() {
	tc-export CC
	# need to force optimization here, as it breaks without
	if   is-flag -O0; then
		replace-flags -O0 -O2
	elif ! is-flag -O?; then
		append-flags -O2
	fi
	# sysdatadir installs a pari.cfg stuff which is informative only
	./Configure \
		--prefix=/usr \
		--datadir=/usr/share/${PN} \
		--libdir=/usr/$(get_libdir) \
		--sysdatadir=/usr/share/doc/${PF} \
		--mandir=/usr/share/man/man1 \
		--with-readline \
		$(use_with gmp) \
		$(use_with mpir) \
		|| die "./Configure failed"
}

src_compile() {
	if use hppa; then
		mymake=DLLD\=/usr/bin/gcc\ DLLDFLAGS\=-shared\ -Wl,-soname=\$\(LIBPARI_SONAME\)\ -lm
	fi

	local installdir=$(get_compile_dir)
	cd "${installdir}" || die "Bad directory"

	# upstream set -fno-strict-aliasing.
	# aliasing is a known issue on amd64, it probably work on x86 by sheer luuck.
	emake ${mymake} CFLAGS="${CFLAGS} -fno-strict-aliasing -DGCC_INLINE -fPIC" lib-dyn \
		|| die "Building shared library failed!"

	if use static; then
		emake ${mymake} CFLAGS="${CFLAGS} -DGCC_INLINE" lib-sta \
			|| die "Building static library failed!"
	fi

	emake ${mymake} CFLAGS="${CFLAGS} -DGCC_INLINE" gp ../gp \
		|| die "Building executables failed!"

	if use doc; then
		cd "${S}"
		# To prevent sandbox violations by metafont
		VARTEXFONTS="${T}"/fonts emake docpdf \
			|| die "Failed to generate docs"
	fi
	if use emacs; then
		cd "${S}/emacs"
		elisp-compile *.el || die "elisp-compile failed"
	fi
}

src_test() {
	emake test-kernel || die
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	if use emacs; then
		elisp-install ${PN} emacs/*.el emacs/*.elc \
			|| die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use data; then
		emake DESTDIR="${D}" install-data || die "Failed to install data files"
	fi

	if use static; then
		emake \
			DESTDIR="${D}" \
			install-lib-sta || die "Install of static library failed"
	fi

	# Do documentation last as we will change directory for the examples.
	dodoc AUTHORS Announce.2.1 CHANGES README NEW MACHINES COMPAT
	if use doc; then
		# install gphelp and the pdf documentations manually.
		# the install-doc target is overkill, installing even the tex sources.
		dobin doc/gphelp
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf || die "Failed to install pdf docs"
		# gphelp looks for some of the tex sources...
		doins doc/*.tex || die "Failed to install tex sources"
		doins doc/translations || die "Failed to install translations"
		# Install the examples - for real.
		local installdir=$(get_compile_dir)
		cd "${installdir}" || die "Bad directory"
		emake \
			EXDIR="${D}/usr/share/doc/${PF}/examples" \
			install-examples || die "Failed to install docs"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
