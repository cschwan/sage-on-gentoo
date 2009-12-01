# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit fortran python sage

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography,
and numerical computation."
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://mirror.switch.ch/mirror/sagemath/src/${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

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
	~sci-libs/givaro-3.2.16
	>=sci-libs/iml-1.0.1
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/maxima-5.19.1[ecl,-sbcl]
	>=sci-libs/mpir-1.2[-nocxx]
	>=sci-libs/libfplll-3.0.12
	>=sci-mathematics/ecm-6.2.1
	>=media-gfx/tachyon-0.98
	>=sci-mathematics/eclib-20080310.7
	>=sci-mathematics/lcalc-1.23[pari]
	>=sci-mathematics/genus2reduction-0.3
	>=dev-lang/R-2.9.2[lapack,readline]
	>=sci-libs/m4ri-20090617
	>=sci-mathematics/gap-4.1.2
	>=sci-mathematics/gap-guava-3.4"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

RESTRICT="mirror"

# TODO: Support maxima with clisp ? Problems that may arise: readline+clisp

# To remove GAP, we need guava
# add this line to DEPEND: >=sci-mathematics/gap-4.4.10
# and look for the customizations sage make to the gap startup file

# TODO: Optimize spkg_* functions, so that one can use mutiple spkg_* calls on
# the same package without unpacking and repacking it everytime

# TODO: reintroduce example use-variable when sage-examples.ebuild is written

# TODO: In order to remove Singular, pay attention to the following steps:
# DEPEND: >=sci-mathematics/singular-3.1.0.4-r1
# rewrite singular ebuild to correctly install libsingular
# check if sage needs a script and specific patches for library
# -e "s:ln -sf Singular sage_singular:ln -sf /usr/bin/Singular sage_singular:g" \
# -e "s:\$SAGE_LOCAL/share/singular:/usr/share/singular:g" \
# 	# fix path to singular headers
# 	spkg_patch "sage-${PV}" "${FILESDIR}/${P}-singular-path-fix.patch"

# TODO: install a menu icon for sage (see homepage and newsgroup for icon, etc)

# @FUNCTION: sage_clean_targets
# @USAGE: <SAGE-MAKEFILE-TARGETS>
# @DESCRIPTION: This function clears the prerequisites and commands of
# <SAGE-MAKEFILE-TARGETS> in deps-makefile. If one wants to use e.g. sqlite from
# portage, call:
#
# sage_clean_targets SQLITE
#
# This replaces in spkg/standard/deps:
#
# $(INST)/$(SQLITE): $(INST)/$(TERMCAP) $(INST)/$(READLINE)
#	$(SAGE_SPKG) $(SQLITE) 2>&1
#
# with
#
# $(INST)/$(SQLITE):
#	@echo "using SQLITE from portage"
#
# so that deps is still a valid makefile but with SQLITE provided by portage
# instead by Sage.
sage_clean_targets() {
	for i in "$@"; do
		sed -i -n "
		# look for the makefile-target we need
		/^\\\$(INST)\/\\\$($i)\:.*/ {
			# clear the target's prerequisites and add a simple 'echo'-command
			# that will inform us that this target will not be built
			s//\\\$(INST)\/\\\$($i)\:\n\t@echo \"using $i from portage\"/p
			: label
			# go to the next line without printing the buffer (note that sed is
			# invoked with '-n') ...
			n
			# and check if its empty - if that is the case the target definition
			# is finished.
			/^\$/ {
				# print empty line ...
				p
				# and exit
				b
			}
			# this is not an empty line, so it must be a line containing
			# commands. Since we do not want these to be executed, we simply do
			# not print them and proceed with the next line
			b label
		}
		# default action: print line
		p
		" "${S}"/spkg/standard/deps
	done
}

pkg_setup() {
	FORTRAN="gfortran"

	fortran_pkg_setup

	# force sage to use our fortran compiler
	export SAGE_FORTRAN="$(which ${FORTRANC})"

	einfo "Sage itself is released under the GPL-2 _or later_ license"
	einfo "However sage is distributed with packages having different licenses."
	einfo "This ebuild unfortunately does too, here is a list of licenses used:"
	einfo "BSD, LGPL, apache 2.0, PYTHON, MIT, public-domain, ZPL and as-is"
}

src_prepare(){
	cd "${S}/spkg/standard"

	# do not generate documentation if not needed
	if ! use doc ; then
		# remove the following line which builds documentation
		sed -i "/\"\$SAGE_ROOT\"\/sage -docbuild all html/d" \
			"${S}/spkg/install" || die "sed failed"

		# remove the same line in the same file in sage_scripts spkg - this
		# package will unpack and overwrite the original "install" file (why ?)
		spkg_sed "sage_scripts-${PV}" -i \
			"/\"\$SAGE_ROOT\"\/sage -docbuild all html/d" "install"

		# TODO: remove documentation (and related tests ?)
	fi

	# verbosity blows up build.log and slows down installation
	sed -i "s:cp -rpv:cp -rp:g" "${S}/makefile"

	sage_clean_targets ATLAS BOEHM_GC SAGE_BZIP2 ECLIB ECM FPLLL FREETYPE GAP \
		GD G2RED GIVARO GNUTLS GSL IML LCALC LIBM4RI LIBPNG LINBOX MAXIMA \
		MERCURIAL MPFI MPFR MPIR NTL PARI READLINE SCONS SQLITE TACHYON ZLIB \
		ZNPOLY

	# patch to make a correct symbolic links
	spkg_sed "sage_scripts-${PV}" -i \
		-e "s:ln -sf gp sage_pari:ln -sf /usr/bin/gp sage_pari:g" \
		spkg-install sage-spkg-install

	# TODO: gphelp is installed only if pari was emerged with USE=doc and
	# documentation additionally needs FEATURES=nodoc _not_ set.
	# TODO: fix directories containing version strings

	# fix pari, ecl, R and singular paths
	spkg_sed "sage_scripts-${PV}" -i \
		-e "s:\$SAGE_LOCAL/share/pari:/usr/share/pari:g" \
		-e "s:\$SAGE_LOCAL/bin/gphelp:/usr/bin/gphelp:g" \
		-e "s:\$SAGE_LOCAL/share/pari/doc:/usr/share/doc/pari-2.3.4-r1:g" \
		-e "s:\$SAGE_LOCAL/lib/ecl:/usr/lib/ecl-9.8.4:g" \
		-e "s:\$SAGE_ROOT/local/lib/R/lib:/usr/lib/R/lib:g" \
		-e "s:\$SAGE_LOCAL/lib/R:/usr/lib/R:g" \
		sage-env

	# patch to use atlas from portage
	spkg_sed "cvxopt-0.9.p8" -i "s:f77blas:blas:g" patches/setup_f95.py \
		patches/setup_gfortran.py

	# fix command for calling maxima
	spkg_sed "sage-${PV}" -i "s:maxima-noreadline:maxima:g" \
		sage/interfaces/maxima.py

	# do not compile R, but rpy2 which is in R's spkg (why ?)
	spkg_patch "r-2.9.2" "${FILESDIR}/${P}-use-R-from-portage.patch"

	# fix RHOME in rpy2
	spkg_nested_sed "r-2.9.2" "rpy2-2.0.6" -i \
		"s:\"\$SAGE_LOCAL\"/lib/R:/usr/lib/R:g" \
		spkg-install

	# fix compilation error for rpy2
	spkg_nested_patch "r-2.9.2" "rpy2-2.0.6" "${FILESDIR}/${P}-fix-rpy2.patch"

	# add system path for python modules
	spkg_sed "sage_scripts-${PV}" -i \
		-e "s:PYTHONPATH=\"\(.*\)\":PYTHONPATH=\"\1\:$(python_get_sitedir)\":g" \
		sage-env
}

src_compile() {
	# TODO: according to the gentoo-amd64 folks the following is a dirty hack -
	# find the package that is causing the error and apply a better solution

	# On amd64 the ABI variable is used by portage to select between 32-
	# (ABI=x86) and 64-bit (ABI=amd64) compilation. This causes problems since
	# SAGE uses this variable but expects it to be '32' or '64'. Unsetting lets
	# SAGE decide what ABI should be
	unset ABI

	# custom cflags cause problems on amd64
	if use amd64 ; then
		unset CFLAGS
		unset CXXFLAGS
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
	sed -i "s/SAGE_ROOT=.*\/opt/SAGE_ROOT=\"\/opt/" "${D}"/opt/bin/sage \
		"${D}"/opt/sage/sage || die "sed failed"

	# TODO: handle generated docs
	dodoc README.txt || die "dodoc failed"

	# Force sage to create files in new location.  This has to be done twice -
	# this time to create the files for gentoo to correctly record as part of
	# the sage install
	"${D}"/opt/sage/sage -c quit
}

pkg_postinst() {
	# make sure files are correctly setup in the new location by running sage
	# as root. This prevent nasty message to be presented to the user.
	/opt/sage/sage -c quit
}
