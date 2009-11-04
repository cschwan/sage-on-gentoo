# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils flag-o-matic fortran

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography,
and numerical computation."
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://mirror.switch.ch/mirror/sagemath/src/${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples"

# TODO: check dependencies
# TODO: use pari with USE=data ?

# TODO: next packages to remove: singular ?, docutils, setuptools

# gsl with USE=cblas ?

CDEPEND=">=dev-lang/R-2.9.2[lapack,readline]
		>=dev-libs/mpfr-2.4.1
		>=dev-libs/ntl-5.4.2
		>=dev-python/cython-0.11.2.1
		>=dev-python/matplotlib-0.99.1
		>=dev-python/numpy-1.3.0[lapack]
		>=net-libs/gnutls-2.2.1
		>=sci-libs/gsl-1.10
		>=sci-libs/lapack-atlas-3.8.3
		>=sci-libs/scipy-0.7
		>=sci-mathematics/maxima-5.19.1
		>=sci-mathematics/pari-2.3.3[gmp]
		>=sys-libs/zlib-1.2.3
		>=app-arch/bzip2-1.0.5
		>=dev-util/mercurial-1.3.1
		>=sys-libs/readline-6.0
		>=media-libs/libpng-1.2.35
		>=dev-db/sqlite-3.6.17
		>=dev-util/scons-1.2.0"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}
		>=app-arch/tar-1.20"

spkg_unpack() {
	# untar spkg and and remove it
	tar -xf "$1.spkg"
	rm "$1.spkg"
	cd "$1"
}

spkg_pack() {
	# tar patched dir and remove it
	cd ..
	tar -cf "$1.spkg" "$1"
	rm -rf "$1"
}

# patch one of sage's spkgs. $1: spkg name, $2: patch name
spkg_patch() {
	spkg_unpack "$1"

	epatch "$2"

	spkg_pack "$1"
}

spkg_sed() {
	spkg_unpack "$1"

	SPKG="$1"
	shift 1
	sed "$@" || die "sed failed"

	spkg_pack "${SPKG}"
}

patch_deps_file() {
	for i in "$@"; do
		epatch "$FILESDIR/use-$i-from-portage.patch"
	done
}

pkg_setup() {
	FORTRAN="gfortran"
	fortran_pkg_setup
	einfo "Sage itself is released under the GPL-2 _or later_ license"
	einfo "However sage is distributed with packages having different licenses."
	einfo "This ebuild unfortunately does too, here is a list of licenses used:"
	einfo "BSD, LGPL, apache 2.0, PYTHON, MIT, public-domain, ZPL and as-is"
}

src_prepare(){
	cd "${S}/spkg/standard"

	# fix sandbox violation error(s)
	spkg_patch "ecm-6.2.1.p0" "$FILESDIR/ecm-6.2.1.p0-fix-typo.patch"
	# TODO: one violation error left - sage tries to write to /etc/ld.so.cache~

	# do not generate documentation if not needed
	if ! use doc ; then
		# remove the following line which builds documentation
		sed -i "/\"\$SAGE_ROOT\"\/sage -docbuild all html/d" \
			"${S}/spkg/install" || die "sed failed"

		# remove the same line in the same files in sage_scripts spkg - this
		# package will unpack and overwrite the original "install" file (why ?)
		spkg_sed "sage_scripts-4.2" -i \
			"/\"\$SAGE_ROOT\"\/sage -docbuild all html/d" "install"
	fi

	# do not make examples if not needed
	if ! use examples ; then
		epatch "$FILESDIR/deps-no-examples.patch"
	fi

	# remove dependencies which will be provided by portage
	patch_deps_file atlas bzip2 gnutls gsl libpng maxima mercurial \
		mpfr ntl pari R readline scons sqlite zlib

	# patch to set PYTHONPATH correctly for all python packages
	# TODO: remove matplotlib, scipy

	# patches to use pari from portage
	spkg_patch "genus2reduction-0.3.p5" \
		"$FILESDIR/g2red-pari-include-fix.patch"
	spkg_patch "lcalc-20080205.p3" "$FILESDIR/lcalc-fix-paths.patch"
	spkg_patch "eclib-20080310.p7" "$FILESDIR/eclib-fix-paths.patch"

	# TODO: anything creates a file sage_pari in 'local/bin' - possibly more
	# patches are needed

	# patches for sage on gentoo
	#spkg_patch "sage-4.2" "$FILESDIR/module_list-fix.patch"

	# patch to use atlas from portage
	spkg_sed "cvxopt-0.9.p8" -i "s/f77blas/blas/g" "patches/setup_f95.py"
	# TODO: patch also setup_gfortran ?

	# patch to use ntl and blas from portage
	# TODO: patch to use gmp from portage
	spkg_patch "linbox-1.1.6.p2" "$FILESDIR/linbox-fix-configure.patch"

	# patch to use mpfr from portage
	spkg_sed "mpfi-1.3.4-cvs20071125.p7" -i \
		"s/--with-mpfr-dir=\"\$SAGE_LOCAL\"/--with-mpfr-dir=\/usr/g" \
		spkg-install

	# TODO: patch to use numpy and cython

	# hopefully sets correct directories
	#export SAGE_DEBIAN=yes
}

src_compile() {
	# This is so (at least) mpir will compile.
	ABI=32
	if ( (use amd64) || (use ppc64) ); then
		ABI=64
	fi

	emake || die "make failed"
	if ( grep "sage: An error occurred" "${S}/install.log" ); then
		die "make failed"
	fi
}

src_install() {
	emake DESTDIR="${D}/opt" install
	sed -i "s/SAGE_ROOT=.*\/opt/SAGE_ROOT=\"\/opt/" "${D}/opt/bin/sage" \
		"${D}/opt/sage/sage"

	# TODO: handle generated docs
	dodoc COPYING.txt HISTORY.txt README.txt || die "dodoc failed"

	# Force sage to create files in new location.  This has to be done twice -
	# this time to create the files for gentoo to correctly record as part of
	# the sage install
	"${D}/opt/sage/sage" -c quit
}

pkg_postinst() {
	# make sure files are correctly setup in the new location by running sage
	# as root. This prevent nasty message to be presented to the user.
	/opt/sage/sage -c quit
}
