# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit multilib python sage flag-o-matic

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography and numerical computation."
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/src/${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc build-doc"

# TODO: should be sci-libs/m4ri-20091120 which is not available on upstream
# TODO: check pygments version string (Sage's pygments version seems very old)
# TODO: check dependencies use flagged packages
# TODO: upgrading mpmath to 0.14 results in some test failures (api changes ?)
CDEPEND=">=app-arch/bzip2-1.0.5
	=dev-lang/python-2.6.4-r99[sqlite]
	>=dev-lang/R-2.10.1[lapack,readline]
	>=dev-libs/mpfr-2.4.2
	>=dev-libs/ntl-5.5.2
	>=dev-python/cython-0.12.1
	>=dev-python/gdmodule-0.56
	>=dev-python/ipython-0.9.1
	>=dev-python/jinja-1.2
	>=dev-python/numpy-1.3.0[lapack]
	>=dev-python/rpy-2.0.6
	>=dev-python/matplotlib-0.99.1
	>=dev-python/mpmath-0.14
	~dev-python/pexpect-2.0
	>=dev-python/pycrypto-2.0.1
	>=dev-python/python-gnutls-1.1.4
	>=dev-python/sympy-0.6.4
	>=net-zope/zodb-3.7.0
	>=net-zope/zope-i18nmessageid-3.5.0
	>=net-zope/zope-testbrowser-3.7.0
	>=sci-libs/flint-1.5.0[ntl]
	>=sci-libs/fplll-3.0.12
	>=sci-libs/ghmm-0.9_rc1[lapack,python]
	=sci-libs/givaro-3.2*
	>=sci-libs/gsl-1.10
	>=sci-libs/iml-1.0.1
	>=sci-libs/lapack-atlas-3.8.3
	>=sci-libs/libcliquer-1.2.5
	>=sci-libs/linbox-1.1.6[ntl,sage]
	>=sci-libs/m4ri-20091101
	>=sci-libs/mpfi-1.3.4
	>=sci-libs/mpir-1.2.2[cxx]
	>=sci-libs/pynac-0.1.10
	>=sys-libs/readline-6.0
	>=sci-libs/symmetrica-2.0
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/eclib-20080310_p10
	>=sci-mathematics/ecm-6.2.1
	|| ( >=sci-mathematics/pari-2.3.3[data,gmp]
	     >=sci-mathematics/pari-2.3.3[data,mpir] )
	>=sci-mathematics/polybori-0.6.4[sage]
	>=sci-mathematics/ratpoints-2.1.3
	>=sci-mathematics/rubiks-20070912_p10
	~sci-mathematics/sage-clib-${PV}
	~sci-mathematics/sage-data-${PV}
	~sci-mathematics/sage-extcode-${PV}
	~sci-mathematics/sage-notebook-0.7.5.3
	virtual/cblas"

DEPEND="${CDEPEND}
	>=dev-python/setuptools-0.6.9
	doc? ( build-doc? ( >=dev-python/sphinx-0.6.3 ) )
	dev-util/pkgconfig"
RDEPEND="${CDEPEND}
	>=dev-python/imaging-1.1.6
	~sci-mathematics/sage-examples-${PV}
	~sci-mathematics/sage-latex-2.2.3
	>=sci-mathematics/gap-4.4.12
	>=sci-mathematics/gap-guava-3.4
	>=sci-mathematics/maxima-5.20.1[ecl]
	>=sci-mathematics/genus2reduction-0.3
	>=sci-mathematics/lcalc-1.23[pari]
	>=sci-mathematics/sympow-1.018
	>=sci-libs/cddlib-094f
	>=sci-mathematics/gfan-0.4
	>=media-gfx/tachyon-0.98
	>=sci-mathematics/flintqs-20070817_p4
	>=sci-mathematics/palp-1.1
	>=sci-libs/scipy-0.7
	>=dev-python/cvxopt-0.9
	dev-python/sqlalchemy[sqlite]
	>=dev-python/sphinx-0.6.3
	doc? ( !build-doc? ( ~sci-mathematics/sage-doc-"${PV}" ) )"

# tests _will_ fail!
RESTRICT="mirror test"

# TODO: In order to remove Singular, pay attention to the following steps:
# DEPEND: >=sci-mathematics/singular-3.1.0.4-r1
# rewrite singular ebuild to correctly install libsingular
# check if sage needs a script and specific patches for library
# -e "s:ln -sf Singular sage_singular:ln -sf /usr/bin/Singular sage_singular:g" \
# -e "s:\$SAGE_LOCAL/share/singular:/usr/share/singular:g" \
# and fix paths to singular

pkg_setup() {
	# disable --as-needed until all bugs related are fixed
	append-ldflags -Wl,--no-as-needed

	# switch to lapack-atlas as some dependencies of sage are linked against it
	# specifically because of clapack.
	OLD_IMPLEM="$(eselect lapack show)"
	einfo "Switching to lapack-atlas with eselect."
	eselect lapack set atlas
}

src_prepare() {
	############################################################################
	# Modifications to the build system and to Sage's scripts
	############################################################################

	# do not let Sage make the following targets
	sage_clean_targets ATLAS BLAS BOEHM_GC BOOST_CROPPED CDDLIB CLIQUER CONWAY \
		CVXOPT CYTHON DOCUTILS ECLIB ECM ELLIPTIC_CURVES EXAMPLES EXTCODE F2C \
		FLINT FLINTQS FPLLL FREETYPE G2RED GAP GD GDMODULE GFAN GHMM GIVARO \
		GNUTLS GRAPHS GSL ICONV IML IPYTHON JINJA JINJA2 LAPACK LCALC LIBM4RI \
		LIBPNG LINBOX MATPLOTLIB MAXIMA MERCURIAL MPFI MPFR MPIR MPMATH NTL \
		NUMPY PALP PARI PEXPECT PIL POLYBORI POLYTOPES_DB PYCRYPTO PYGMENTS \
		PYNAC PYPROCESSING PYTHON_GNUTLS PYTHON R RATPOINTS READLINE RUBIKS \
		SAGE_BZIP2 SAGENB SAGETEX SCIPY SCIPY_SANDBOX SCONS SETUPTOOLS SPHINX \
		SQLALCHEMY SQLITE SYMMETRICA SYMPOW SYMPY TACHYON TERMCAP TWISTED \
		TWISTEDWEB2 WEAVE ZLIB ZNPOLY ZODB

	# no verbose copying, copy links and do not change permissions
	# Make sure that "make test" doesn't build doc
	sed -i \
		-e "s:cp -rpv:cp -r --preserve=mode,links:g" \
		-e "s/all: build doc/all: build/g" \
		makefile || die "sed failed ifor the makefile"

	# disable generation of documentation
	sage_package sage_scripts-${PV} \
		sed -i "/\"\$SAGE_ROOT\"\/sage -docbuild all html/d" install \
		|| die "sed failed"

	# patch to make correct symbolic links
	sage_package sage_scripts-${PV} \
		sed -i "s:ln -sf gp sage_pari:ln -sf /usr/bin/gp sage_pari:g" \
		spkg-install sage-spkg-install

	# TODO: gphelp is installed only if pari was emerged with USE=doc and
	# documentation additionally needs FEATURES=nodoc _not_ set.
	# TODO: fix directories containing version strings

	# fix pari, ecl, R and singular paths
	sage_package sage_scripts-${PV} \
		sed -i \
		-e "s:\$SAGE_LOCAL/share/pari:/usr/share/pari:g" \
		-e "s:\$SAGE_LOCAL/bin/gphelp:/usr/bin/gphelp:g" \
		-e "s:\$SAGE_LOCAL/share/pari/doc:/usr/share/doc/pari-2.3.4-r1:g" \
		-e "s:\$SAGE_ROOT/local/lib/R/lib:/usr/lib/R/lib:g" \
		-e "s:\$SAGE_LOCAL/lib/R:/usr/lib/R:g" \
		-e "s:ECLDIR=:#ECLDIR=:g" \
		sage-env

	# add system path for python modules
	sage_package sage_scripts-${PV} \
		sed -i \
		-e "s:\"\$SAGE_ROOT/local/lib/python\":\"\$SAGE_ROOT/local/$(get_libdir)/python\":g" \
		-e "s:PYTHONPATH=\"\(.*\)\":PYTHONPATH=\"$(python_get_sitedir)\:\1\:\$SAGE_ROOT/local/$(get_libdir)/python/site-packages\":g" \
		-e "/PYTHONHOME=.*/d" \
		sage-env

	# create this directory manually
	mkdir -p "${S}"/local/$(get_libdir)/python2.6/site-packages \
		|| die "mkdir failed"

	cd "${S}"/local
	# make sure the lib directory exists
	if [[ ! -d lib ]] ; then
		ln -s $(get_libdir) lib || die "ln failed"
	fi

	# TODO: check if this is needed

	# make unversioned symbolic link
	cd "${S}"/local/$(get_libdir)
	ln -s python2.6 python || die "ln failed"

	############################################################################
	# Fixes to sage itself
	############################################################################

	# run maxima with ecl
	sage_package ${P} \
		sed -i \
		-e "s:maxima-noreadline:maxima -l ecl:g" \
		-e "s:maxima --very-quiet:maxima -l ecl --very-quiet:g" \
		sage/interfaces/maxima.py

	# fix missing libraries needed with "--as-needed"
	sage_package ${P} \
		epatch "${FILESDIR}"/${PN}-4.3.2-fix-undefined-symbols.patch

	# TODO: At least one more patch needed: devel/sage/sage/misc/misc.py breaks

	# TODO: why does Sage fail with commentator ?
# 	# disable linbox commentator which is too verbose and confuses Sage
# 	sage_package ${P} \
# 		epatch "${FILESDIR}"/${PN}-4.3.2-disable-linbox-commentator.patch

	# TODO: Are these needed ?
	sage_package ${P} \
		sed -i \
		-e "s:SAGE_ROOT +'/local/include/fplll':'/usr/include/fplll':g" \
		-e "s:SAGE_ROOT + \"/local/include/ecm.h\":\"/usr/include/ecm.h\":g" \
		-e "s:SAGE_ROOT + \"/local/include/png.h\":\"/usr/include/png.h\":g" \
		-e "s:SAGE_ROOT + \"/local/include/symmetrica/def.h\":\"/usr/include/symmetrica/def.h\":g" \
		module_list.py

	# TODO: -e "s:SAGE_ROOT + \"/local/include/fplll/fplll.h\":\"\":g" \
	# this file does not exist

	# fix paths for flint, pynac/ginac, numpy and polybori
	sage_package ${P} \
		sed -i \
		-e "s:SAGE_ROOT+'/local/include/FLINT/':'/usr/include/FLINT/':g" \
		-e "s:SAGE_ROOT + \"/local/include/FLINT/flint.h\":\"/usr/include/FLINT/flint.h\":g" \
		-e "s:SAGE_ROOT + \"/local/include/pynac/ginac.h\":\"/usr/include/pynac/ginac.h\":g" \
		-e "s:SAGE_ROOT+'/local/lib/python/site-packages/numpy/core/include':'/usr/lib/python2.6/site-packages/numpy/core/include':g" \
		-e "s:SAGE_LOCAL + \"/share/polybori/flags.conf\":\"/usr/share/polybori/flags.conf\":g" \
		-e "s:SAGE_ROOT+'/local/include/cudd':'/usr/include/cudd':g" \
		-e "s:SAGE_ROOT+'/local/include/polybori':'/usr/include/polybori':g" \
		-e "s:SAGE_ROOT+'/local/include/polybori/groebner':'/usr/include/polybori/groebner':g" \
		-e "s:SAGE_ROOT + \"/local/include/polybori/polybori.h\":\"/usr/include/polybori/polybori.h\":g" \
		module_list.py

	# remove csage which is built elsewhere
	sage_package ${P} \
		epatch "${FILESDIR}"/${PN}-4.3.1-remove-csage.patch
	sage_package sage_scripts-${PV} \
		epatch "${FILESDIR}"/${PN}-4.3.1-remove-csage-2.patch

	# fix csage include
	sage_package ${P} \
		sed -i "s:'%s/include/csage'%SAGE_LOCAL:'/usr/include/csage':g" setup.py
	sage_package ${P} \
		sed -i "s:'%s/local/include/csage/'%SAGE_ROOT:'/usr/include/csage/':g" \
		sage/misc/cython.py

	# TODO: maybe there are more paths to fix in sage/misc/cython.py

	# remove csage files which are not needed
	sage_package ${P} \
		rm -rf c_lib

	# unset custom C(XX)FLAGS - this is just a temporary hack
	sage_package ${P} \
		epatch "${FILESDIR}"/${PN}-4.3.1-amd64-hack.patch

	# set path to Sage's cython
	sage_package ${P} \
		sed -i "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/':'/usr/$(get_libdir)/python2.6/site-packages/Cython/Includes/':g" \
		setup.py

	# fix site-packages check
	sage_package ${P} \
		sed -i "s:'%s/lib/python:'%s/$(get_libdir)/python:g" setup.py

	# Ticket #7803:
	# apply patches fixing deprecation warning which interfers with test output
	sage_package ${P} \
		epatch "${FILESDIR}"/${PN}-4.3.1-combinat-sets-deprecation.patch

	# use delaunay from matplotlib (see ticket #6946)
	sage_package ${P} \
		epatch "${FILESDIR}"/${PN}-4.3.1-delaunay-from-matplotlib.patch

	# use arpack from scipy (see also scipy ticket #231)
	sage_package ${P} \
		epatch "${FILESDIR}"/${PN}-4.3.1-arpack-from-scipy.patch

	# fix gap problem reported by Marek - hopefully.
	sage_package ${P} \
		sed -i "s:cmd += \" -b -p -T\":cmd += \" -b -T\":g" sage/interfaces/gap.py

	# Replace gmp with mpir
# 	sage_package ${P} \
# 		sed -i "s:gmp\.h:mpir.h:g" \
# 			module_list.py \
# 			sage/libs/gmp/types.pxd \
# 			sage/combinat/partitions_c.cc \
# 			sage/combinat/partitions_c.h \
# 			sage/combinat/partitions.pyx \
# 			sage/ext/cdefs.pxi \
# 			sage/libs/gmp/mpf.pxd \
# 			sage/libs/gmp/mpn.pxd \
# 			sage/libs/gmp/mpq.pxd \
# 			sage/libs/gmp/mpz.pxd \
# 			sage/libs/gmp/random.pxd \
# 			sage/libs/gmp/types.pxd \
# 			sage/libs/linbox/matrix_rational_dense_linbox.cpp \
# 			sage/misc/cython.py \
# 			sage/rings/memory.pyx \
# 			sage/rings/bernmm/bern_modp.cpp \
# 			sage/rings/bernmm/bern_rat.cpp \
# 			sage/rings/bernmm/bern_rat.h \
# 			sage/rings/bernmm/bernmm-test.cpp \
# 			sage/rings/integer.pyx || die "sed failed"

# 	sage_package ${P} \
# 		sed -i \
# 			-e "s:'gmp':'mpir':g" \
# 			-e "s:\"gmp\":\"mpir\":g" \
# 			-e "s:'gmpxx':'mpirxx':g" \
# 			-e "s:\"gmpxx\":\"mpirxx\":g" \
# 			module_list.py sage/misc/cython.py || die "sed failed"

	############################################################################
	# Modifications to other packages
	############################################################################

	# save versioned package names
	local MOINMOIN=moin-1.9.1.p1
	local NETWORKX=networkx-0.99.p1-fake_really-0.36.p1

	# apply patches fixing deprecation warning which interfers with test output
	sage_package ${NETWORKX} \
		epatch "${FILESDIR}"/${PN}-4.3.1-networkx-sets-deprecation.patch

	############################################################################
	# Prefixing of Python packages
	############################################################################

	local SPKGS_NEEDING_FIX=( ${MOINMOIN} )

	# fix installation paths - this must be done in order to remove python
	for i in "${SPKGS_NEEDING_FIX[@]}" ; do
		sage_package $i \
			sed -i "s:python setup.py install:python setup.py install --prefix=\"\${SAGE_LOCAL}\":g" \
			spkg-install
	done

	# same for sage spkg in install file
	sage_package ${P} \
		sed -i "s:python setup.py install:python setup.py install --prefix=\"\${SAGE_LOCAL}\":g" \
		install

	# fix installation paths
	sage_package ${NETWORKX} \
		sed -i "s:python setup.py install --home=\"\$SAGE_LOCAL\":python setup.py install --prefix=\"\${SAGE_LOCAL}\":g" \
		spkg-install

	# pack all unpacked spkgs
	sage_package_finish
}

src_compile() {
	# Sage's makefile just does this
	cd spkg; ./install || die "install failed"

	# check if everything did successfully built
	grep -s "Error building Sage" install.log && die "Sage build failed"

	# Generate documentation, or not!
	if ( use doc && use build-doc ); then
		"${S}"/sage -docbuild all html
	# pdf is slooooooooow and it may need some specific tex packages to identify.
#		"${S}"/sage -docbuild all pdf
	else
		rm -rf "${S}"/devel/sage-main/doc/output/html/*
	fi

}

src_install() {
	# install docs
	dodoc README.txt || die "dodoc failed"

	# remove *.spkg files which will not be needed since sage must be upgraded
	# using portage, this saves about 400 MB
	for i in spkg/standard/*.spkg ; do
		rm $i || die "rm failed"
		touch $i || die "touch failed"
	done

	# remove file not needed
	cd devel/sage-main
	rm -rf bundle export install MANIFEST.in module_list.py PKG-INFO pull \
		README.txt sage-push setup.py spkg-delauto spkg-dist spkg-install \
		build/lib.* build/temp.* || die "rm failed"
	cd ../..

	# these files are not needed
	rm -rf .BUILDSTART COPYING.txt README.txt sage-README-osx.txt spkg/build/* \
		tmp || die "rm failed"

	# remove mercurial directories - these are not needed
	hg_clean

	# TODO: write own installation routine which copies only files needed

	# install files
	emake DESTDIR="${D}${SAGE_PREFIX}" install || die "emake install failed"

	# TODO: create additional desktop files

	# install entries for desktop managers
	doicon "${FILESDIR}"/sage.svg || die "doicon failed"
	domenu "${FILESDIR}"/sage-shell.desktop || die "domenu failed"
# 	domenu "${FILESDIR}"/sage-notebook.desktop || die "domenu failed"

# 	# install entry for documentation if available
# 	use doc && domenu "${FILESDIR}"/sage-documentation.desktop \
# 		|| die "domenu failed"

	# fix installation path
	sed -i "s:${D}::" "${D}/${SAGE_PREFIX}"/bin/sage "${D}/${SAGE_ROOT}"/sage \
		|| die "sed failed"
}

pkg_postinst() {
	# make sure files are correctly setup in the new location by running sage
	# as root. This prevent nasty message to be presented to the user.
	"${SAGE_ROOT}"/sage -c

	if ( ! use doc ); then
		ewarn "You haven't installed/built the documentation."
		ewarn "This means the html documentation won't be available in sage notebook."
	fi

	# Restoring the original lapack settings.
	einfo "Restoring your original lapack settings with eselect"
	if ( grep lib64 <<< ${OLD_IMPLEM} ); then
		eselect lapack set "${OLD_IMPLEM:7}"
	else
		eselect lapack set "${OLD_IMPLEM:5}"
	fi
}

pkg_postrm() {
	python_mod_cleanup "${SAGE_ROOT}"
}