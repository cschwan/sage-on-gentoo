# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/R/R-2.14.0.ebuild,v 1.1 2011/11/21 16:22:52 jlec Exp $

EAPI=4

inherit bash-completion-r1 eutils flag-o-matic fortran-2 versionator autotools

DESCRIPTION="Language and environment for statistical computing and graphics"
HOMEPAGE="http://www.r-project.org/"
SRC_URI="
	mirror://cran/src/base/R-2/${P}.tar.gz
	bash-completion? ( mirror://gentoo/R.bash_completion.bz2 )"

LICENSE="|| ( GPL-2 GPL-3 ) LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-macos ~x64-macos"
IUSE="bash-completion cairo doc java jpeg lapack minimal nls openmp perl png profile readline static-libs tk X"

# common depends
CDEPEND="
	app-arch/bzip2
	app-text/ghostscript-gpl
	dev-libs/libpcre
	!prefix? (
		|| ( >=net-libs/libtirpc-0.2.2-r1 <sys-libs/glibc-2.14 sys-freebsd/freebsd-lib )
	)
	virtual/blas
	cairo? ( x11-libs/cairo[X] )
	jpeg? ( virtual/jpeg )
	lapack? ( virtual/lapack )
	perl? ( dev-lang/perl )
	png? ( media-libs/libpng )
	readline? ( sys-libs/readline )
	tk? ( dev-lang/tk )
	X? ( x11-libs/libXmu x11-misc/xdg-utils )"

DEPEND="${CDEPEND}
	dev-util/pkgconfig
	doc? (
			virtual/latex-base
			dev-texlive/texlive-fontsrecommended
		   )"

RDEPEND="${CDEPEND}
	( || ( <sys-libs/zlib-1.2.5.1-r1 >=sys-libs/zlib-1.2.5.1-r2[minizip] ) )
	app-arch/xz-utils
	java? ( >=virtual/jre-1.5 )"

RESTRICT="minimal? ( test )"

R_DIR="${EPREFIX}/usr/$(get_libdir)/${PN}"

pkg_setup() {
	if use openmp; then
		FORTRAN_NEED_OPENMP=1
		tc-has-openmp || die "Please enable openmp support in your compiler"
	fi
	fortran-2_pkg_setup
	filter-ldflags -Wl,-Bdirect -Bdirect
	# avoid using existing R installation
	unset R_HOME
}

src_prepare() {
	# fix ocasional failure with parallel install (bug #322965)
	# upstream in R-2.13?
	# https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=14505
	epatch "${FILESDIR}"/${PN}-2.11.1-parallel.patch
	# respect ldflags on rscript
	# upstream does not want it, no reasons given
	# https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=14506
	epatch "${FILESDIR}"/${PN}-2.12.1-ldflags.patch
	# update for zlib header changes (see bug #383431)
	epatch "${FILESDIR}"/${PN}-2.13.1-zlib_header_fix.patch

	# glibc 2.14 removed rpc
	if has_version '>=net-libs/libtirpc-0.2.2-r1'; then
		append-cppflags $($(tc-getPKG_CONFIG) libtirpc --cflags)
		export LIBS+=" $($(tc-getPKG_CONFIG) libtirpc --libs)"
		# patching configure.ac would cause way too much work
		# ugly hack on configure and let upstream do the job
		sed -i -e "s/'' nsl;/'' tirpc;/" configure || die
	fi

	# fix packages.html for doc (bug #205103)
	# check in later versions if fixed
	sed -i \
		-e "s:../../library:../../../../$(get_libdir)/R/library:g" \
		src/library/tools/R/Rd.R \
		|| die "sed failed"

	# fix Rscript
	sed -i \
		-e "s:-DR_HOME='\"\$(rhome)\"':-DR_HOME='\"${R_DIR}\"':" \
		src/unix/Makefile.in || die "sed unix Makefile failed"

	# fix HTML links to manual (bug #273957)
	sed -i -e 's:\.\./manual/:manual/:g' $(grep -Flr ../manual/ doc) \
		|| die "sed for HTML links to manual failed"

	use lapack && \
		export LAPACK_LIBS="$(pkg-config --libs lapack)"

	if use X; then
		export R_BROWSER="$(type -p xdg-open)"
		export R_PDFVIEWER="$(type -p xdg-open)"
	fi
	use perl && \
		export PERL5LIB="${S}/share/perl:${PERL5LIB:+:}${PERL5LIB}"

	# Fix for darwin (OS X)
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -e 's:-install_name libR.dylib:-install_name ${libdir}/R/lib/libR.dylib:' \
			-e 's:-install_name libRlapack.dylib:-install_name ${libdir}/R/lib/libRlapack.dylib:' \
			-e 's:-install_name libRblas.dylib:-install_name ${libdir}/R/lib/libRblas.dylib:' \
			-e "s:AM_INIT_AUTOMAKE:A_I_A:" \
			-e "s:SHLIB_EXT=\".so:SHLIB_EXT=\".dylib:" \
			-i configure.ac

	      AT_M4DIR=m4	eautoreconf
	      elibtoolize
	fi
}

src_configure() {
	econf \
		--enable-byte-compiled-packages \
		--enable-R-shlib \
		--with-system-zlib \
		--with-system-bzlib \
		--with-system-pcre \
		--with-system-xz \
		--with-blas="$(pkg-config --libs blas)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		rdocdir="${EPREFIX}/usr/share/doc/${PF}" \
		--enable-R-framework=no \
		$(use_enable openmp) \
		$(use_enable nls) \
		$(use_enable profile R-profiling) \
		$(use_enable profile memory-profiling) \
		$(use_enable static-libs static) \
		$(use_enable static-libs R-static-lib) \
		$(use_with lapack) \
		$(use_with tk tcltk) \
		$(use_with jpeg jpeglib) \
		$(use_with !minimal recommended-packages) \
		$(use_with png libpng) \
		$(use_with readline) \
		$(use_with cairo) \
		$(use_with X x)
}

src_compile(){
	export VARTEXFONTS="${T}/fonts"
	emake
	RMATH_V=0.0.0
	if [[ ${CHOST} == *-darwin* ]] ; then
		emake -j1 -C src/nmath/standalone \
			libRmath_la_LDFLAGS="-install_name ${EPREFIX}/usr/$(get_libdir)/libRmath.dylib" \
			libRmath_la_LIBADD="\$(LIBM)" \
			|| die "emake math library failed"
	else
		emake -C src/nmath/standalone \
			libRmath_la_LDFLAGS="-Wl,-soname,libRmath.so.${RMATH_V}" \
			libRmath_la_LIBADD="\$(LIBM)" \
			shared $(use static-libs && echo static)
	fi
	use doc && emake info pdf
}

src_install() {
	default
	if use doc; then
		emake DESTDIR="${D}" install-info install-pdf
		dosym ../manual /usr/share/doc/${PF}/html/manual
	fi

	# standalone math lib install (-j1 basically harmless)
	emake \
		-C src/nmath/standalone \
		DESTDIR="${D}" install

	if [[ ${CHOST} != *-darwin* ]] ; then
		local mv=$(get_major_version ${RMATH_V})
		mv  "${ED}"/usr/$(get_libdir)/libRmath.so \
			"${ED}"/usr/$(get_libdir)/libRmath.so.${RMATH_V}
		dosym libRmath.so.${RMATH_V} /usr/$(get_libdir)/libRmath.so.${mv}
		dosym libRmath.so.${mv} /usr/$(get_libdir)/libRmath.so
	fi

	if [[ ${CHOST} == *-darwin* ]] ; then
		einfo "Working around completely broken build-system(tm)"
		for d in $(find "${ED}"usr/lib/R/ -name *.dylib) ; do
			if [[ -f ${d} ]] ; then
				# fix the "soname"
				ebegin "  correcting install_name of ${d#${ED}}"
				install_name_tool -id "/${d#${D}}" "${d}"
				eend $?
			fi
		done
	fi

	# env file
	cat > 99R <<-EOF
		LDPATH=${R_DIR}/lib
		R_HOME=${R_DIR}
	EOF
	doenvd 99R
	use bash-completion && dobashcomp "${WORKDIR}"/R.bash_completion
}

pkg_postinst() {
	if use java; then
		einfo "Re-initializing java paths for ${P}"
		R CMD javareconf
	fi
}
