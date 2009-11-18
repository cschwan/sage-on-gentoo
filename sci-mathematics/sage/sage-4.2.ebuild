# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit fortran

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography,
and numerical computation."
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://mirror.switch.ch/mirror/sagemath/src/${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

# TODO: check dependencies

CDEPEND="
	>=dev-libs/mpfr-2.4.1
	|| (
		>=dev-libs/ntl-5.4.2[gmp]
		>=dev-libs/ntl-5.5.2
	)
	>=net-libs/gnutls-2.2.1
	>=sci-libs/gsl-1.10
	>=sci-libs/lapack-atlas-3.8.3
	>=sci-mathematics/pari-2.3.3[data,gmp]
	>=sys-libs/zlib-1.2.3
	>=app-arch/bzip2-1.0.5
	>=dev-util/mercurial-1.3.1
	>=sys-libs/readline-6.0
	>=media-libs/libpng-1.2.35
	>=dev-db/sqlite-3.6.17
	>=dev-util/scons-1.2.0
	>=media-libs/gd-2.0.35
	>=media-libs/freetype-2.3.5
	>=sci-libs/linbox-1.1.6[ntl,sage]
	>=sci-libs/mpfi-1.3.4
	>=sci-libs/givaro-3.2.13
	>=sci-libs/iml-1.0.1
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/maxima-5.19.1[ecl,-sbcl]"
DEPEND="${CDEPEND}
	>=app-arch/tar-1.20"
RDEPEND="${CDEPEND}"

RESTRICT="mirror"

# TODO: Support maxima with clisp ? Problems that may arise: readline+clisp

# To remove R, add
# >=dev-lang/R-2.9.2[lapack,readline] to DEPEND,
# change RHOME in sage-env
# and LD_LIBRARY_PATH in the same file and check if depend on internal rpy2

# TODO: Optimize spkg_* functions, so that one can use mutiple spkg_* calls on
# the same package without unpacking and repacking it everytime

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

	# force sage to use our fortran compiler
	export SAGE_FORTRAN="${FORTRANC}"

	einfo "Sage itself is released under the GPL-2 _or later_ license"
	einfo "However sage is distributed with packages having different licenses."
	einfo "This ebuild unfortunately does too, here is a list of licenses used:"
	einfo "BSD, LGPL, apache 2.0, PYTHON, MIT, public-domain, ZPL and as-is"
}

src_prepare(){
	cd "${S}/spkg/standard"

	# fix sandbox violation errors
	spkg_patch "ecm-6.2.1.p0" "$FILESDIR/ecm-6.2.1.p0-fix-typo.patch"
	spkg_sed "zlib-1.2.3.p4" -i "/ldconfig/d" src/Makefile src/Makefile.in

	# do not generate documentation if not needed
	if ! use doc ; then
		# remove the following line which builds documentation
		sed -i "/\"\$SAGE_ROOT\"\/sage -docbuild all html/d" \
			"${S}/spkg/install" || die "sed failed"

		# remove the same line in the same file in sage_scripts spkg - this
		# package will unpack and overwrite the original "install" file (why ?)
		spkg_sed "sage_scripts-4.2" -i \
			"/\"\$SAGE_ROOT\"\/sage -docbuild all html/d" "install"

		# TODO: remove documentation (and related tests ?)
	fi

	# do not make examples if not needed
	if ! use examples ; then
		epatch "$FILESDIR/deps-no-examples.patch"

		# TODO: remove examples (and related tests ?)
	fi

	# verbosity blows up build.log and slows down installation
	sed -i "s/cp -rpv/cp -rp/g" "${S}/makefile"

	# TODO: patch to set PYTHONPATH correctly for all python packages

	# remove dependencies which will be provided by portage
	patch_deps_file atlas boehmgc bzip2 freetype givaro gd gnutls iml gsl \
		libpng linbox maxima mercurial mpfi mpfr ntl pari readline scons \
		sqlite zlib znpoly

	# patches to use pari from portage
	spkg_patch "genus2reduction-0.3.p5" \
		"$FILESDIR/g2red-pari-include-fix.patch"
	spkg_patch "lcalc-20080205.p3" "$FILESDIR/lcalc-fix-paths.patch"
	spkg_patch "eclib-20080310.p7" "$FILESDIR/eclib-fix-paths.patch"

	# patch to make a correct symbolic link to gp
	spkg_sed "sage_scripts-4.2" -i \
		"s/ln -sf gp sage_pari/ln -sf \/usr\/bin\/gp sage_pari/g" \
		"spkg-install" "sage-spkg-install"

	# TODO: gphelp is installed only if pari was emerged with USE=doc and
	# documentation additionally needs FEATURES=nodoc _not_ set.

	# TODO: documentation contains a version string

	# fix pari paths
	spkg_sed "sage_scripts-4.2" -i \
		-e "s/\$SAGE_LOCAL\/share\/pari/\/usr\/share\/pari/g" \
		-e "s/\$SAGE_LOCAL\/bin\/gphelp/\/usr/\/bin\/gphelp/g" \
		-e "s/\$SAGE_LOCAL\/share\/pari\/doc/\/usr/share\/doc\/pari-2.3.4-r1/g" \
		"sage-env"

	# patch to use atlas from portage
	spkg_sed "cvxopt-0.9.p8" -i "s/f77blas/blas/g" "patches/setup_f95.py" \
		"patches/setup_gfortran.py"

	# fix command for calling maxima
	spkg_sed "sage-4.2" -i "s/maxima-noreadline/maxima/g" \
		"sage/interfaces/maxima.py"

	# TODO: fix the following library path - it contains a version string

	# fix ecl library path
	spkg_sed "sage_scripts-4.2" -i \
		"s/\$SAGE_LOCAL\/lib\/ecl\//\/usr\/lib\/ecl-9.8.4\//g" "sage-env"
}

src_compile() {
	# On amd64 the ABI variable is used by portage to select between 32-
	# (ABI=x86) and 64-bit (ABI=amd64) compilation. This causes problems since
	# SAGE uses this variable but expects it to be '32' or '64'. Unsetting lets
	# SAGE decide what ABI should be
	env -u ABI

	# TODO: Custom flags may cause serious problems on amd64 - mpir ?
	if use amd64 ; then
		env -u CFLAGS
		env -u CXXFLAGS
	fi

	# do not run parallel since this is impossible with SAGE (!?)
	emake -j1 || die "emake failed"

	# TODO: Do we need this ?
	if ( grep "sage: An error occurred" "${S}/install.log" ); then
		die "make failed"
	fi
}

src_install() {
	emake DESTDIR="${D}/opt" install || die "emake install failed"

	# set sage's correct path to /opt
	sed -i "s/SAGE_ROOT=.*\/opt/SAGE_ROOT=\"\/opt/" "${D}/opt/bin/sage" \
		"${D}/opt/sage/sage" || die "sed failed"

	# TODO: handle generated docs
	dodoc HISTORY.txt README.txt || die "dodoc failed"

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
