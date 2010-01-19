# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit multilib python sage

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography and numerical computation."
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/src/${P}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

# TODO: should be sci-libs/m4ri-20091120 which is not available on upstream
# TODO: check pygments version string (Sage's pygments version seems very old)
# TODO: find out version for ghmm
CDEPEND="
	>=dev-libs/mpfr-2.4.1
	|| (
		>=dev-libs/ntl-5.4.2[gmp]
		>=dev-libs/ntl-5.5.2
	)
	>=net-libs/gnutls-2.2.1
	>=sci-libs/gsl-1.10
	>=sci-mathematics/pari-2.3.3[data,gmp]
	>=sys-libs/zlib-1.2.3
	>=app-arch/bzip2-1.0.5
	>=sys-libs/readline-6.0
	>=media-libs/libpng-1.2.35
	>=dev-db/sqlite-3.6.17
	>=media-libs/gd-2.0.35
	>=media-libs/freetype-2.3.5
	>=sci-libs/linbox-1.1.6[ntl,sage]
	>=sci-libs/mpfi-1.3.4
	=sci-libs/givaro-3.2*
	>=sci-libs/iml-1.0.1
	>=sci-libs/zn_poly-0.9
	>=sci-mathematics/maxima-5.19.1[ecl,-sbcl]
	>=sci-libs/mpir-1.2.2[-nocxx]
	>=sci-libs/libfplll-3.0.12
	>=sci-mathematics/ecm-6.2.1
	>=media-gfx/tachyon-0.98
	>=sci-mathematics/eclib-20080310
	>=sci-mathematics/lcalc-1.23[pari]
	>=sci-mathematics/genus2reduction-0.3
	>=dev-lang/R-2.9.2[lapack,readline]
	>=sci-libs/m4ri-20091101
	>=sci-mathematics/gap-4.1.2
	>=sci-mathematics/gap-guava-3.4
	>=sci-mathematics/palp-1.1
	>=sci-mathematics/ratpoints-2.1.2
	>=sci-libs/libcliquer-1.2.2
	>=dev-lang/f2c-20060507
	virtual/cblas
	virtual/lapack
	>=sci-libs/cddlib-094f
	=sci-mathematics/gfan-0.3*
	>=sci-libs/flint-1.5.0[ntl]
	>=sci-mathematics/flintqs-20070817_p4
	=sci-mathematics/sage-data-${PV}
	=sci-mathematics/sage-extcode-${PV}
	>=sci-libs/symmetrica-2.0
	>=sci-mathematics/sympow-1.018
	>=sci-mathematics/rubiks-20070912_p9
	=sci-mathematics/sage-examples-${PV}
	>=dev-python/cython-0.12
	>=dev-python/setuptools-0.6.9
	>=dev-python/docutils-0.5
	>=sci-libs/scipy-0.7
	>=dev-python/numpy-1.3.0[lapack]
	>=dev-python/cvxopt-0.9
	>=dev-python/rpy-2.0.6
	>=dev-python/matplotlib-0.99.1
	>=dev-python/pyprocessing-0.52
	>=dev-python/pygments-0.11.1
	>=dev-python/sympy-0.6.4
	>=dev-python/gdmodule-0.56
	>=dev-python/mpmath-0.13
	>=dev-python/pexpect-2.0
	>=dev-python/pycrypto-2.0.1
	>=dev-python/python-gnutls-1.1.4
	>=dev-python/jinja-1.2
	>=dev-python/jinja2-2.1.1
	>=dev-python/imaging-1.1.6
	>=dev-libs/boost-1.34.1
	sci-libs/ghmm[lapack,python]
	>=sci-libs/pynac-0.1.10
	>=dev-python/ipython-0.9.1
	>=sci-mathematics/polybori-0.6.3[sage]
	=dev-lang/python-2.6*[sqlite]
	>=dev-python/twisted-8.2.0
	>=dev-python/twisted-conch-8.2.0
	>=dev-python/twisted-lore-8.2.0
	>=dev-python/twisted-mail-8.2.0
	>=dev-python/twisted-web2-8.1.0
	>=dev-python/twisted-words-8.2.0
	>=net-zope/zodb-3.7.0
	=dev-lang/python-2.6.4-r1
"

DEPEND="
	${CDEPEND}
	dev-util/pkgconfig
	>=dev-util/scons-1.2.0
"
RDEPEND="${CDEPEND}"

# tests _will_ fail!
RESTRICT="mirror test"

# TODO: Support maxima with clisp ? Problems that may arise: readline+clisp

# TODO: In order to remove Singular, pay attention to the following steps:
# DEPEND: >=sci-mathematics/singular-3.1.0.4-r1
# rewrite singular ebuild to correctly install libsingular
# check if sage needs a script and specific patches for library
# -e "s:ln -sf Singular sage_singular:ln -sf /usr/bin/Singular sage_singular:g" \
# -e "s:\$SAGE_LOCAL/share/singular:/usr/share/singular:g" \
# and fix paths to singular

pkg_setup() {
	einfo "Sage itself is released under the GPL-2 _or later_ license"
	einfo "However sage is distributed with packages having different licenses."
	einfo "This ebuild unfortunately does too, here is a list of licenses used:"
	einfo "BSD, LGPL, apache 2.0, PYTHON, MIT, public-domain, ZPL and as-is"
}

src_prepare(){
	# do not let Sage make the following targets
	sage_clean_targets ATLAS BLAS BOEHM_GC BOOST_CROPPED CDDLIB CLIQUER CONWAY \
		CVXOPT CYTHON DOCUTILS ECLIB ECM ELLIPTIC_CURVES EXAMPLES EXTCODE F2C \
		FLINT FLINTQS FPLLL FREETYPE G2RED GAP GD GDMODULE GFAN GHMM GIVARO \
		GNUTLS GRAPHS GSL IML IPYTHON JINJA JINJA2 LAPACK LCALC LIBM4RI LIBPNG \
		LINBOX MATPLOTLIB MAXIMA MERCURIAL MPFI MPFR MPIR MPMATH NTL NUMPY \
		PALP PARI PEXPECT PIL POLYBORI POLYTOPES_DB PYCRYPTO PYGMENTS PYNAC \
		PYPROCESSING PYTHON_GNUTLS PYTHON R RATPOINTS READLINE RUBIKS \
		SAGE_BZIP2 SCIPY SCONS SETUPTOOLS SQLITE SYMMETRICA SYMPOW SYMPY \
		TACHYON TERMCAP TWISTED TWISTEDWEB2 WEAVE ZLIB ZNPOLY ZODB

	# disable verbose copying but copy symbolic links
	sed -i "s:cp -rpv:cp -r --preserve=mode,ownership,timestamps,links:g" \
		makefile || die "sed failed"

	# disable documentation if not needed
	use doc || sage_package sage_scripts-${PV} \
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

	# fix command for calling maxima
	sage_package ${P} \
		sed -i "s:maxima-noreadline:maxima:g" sage/interfaces/maxima.py

	# extcode is a seperate ebuild - hack to prevent spkg-install from exiting
	sage_package moin-1.5.7.p3 \
		sed -i "s:echo \"Error missing jsmath directory.\":false \&\& \\\\:g" \
		spkg-install

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

	# this file is taken from portage's scipy ebuild
	cat > "${T}"/site.cfg <<-EOF
		[DEFAULT]
		library_dirs = /usr/$(get_libdir)
		include_dirs = /usr/include
		[atlas]
		include_dirs = $(pkg-config --cflags-only-I \
			cblas | sed -e 's/^-I//' -e 's/ -I/:/g')
		library_dirs = $(pkg-config --libs-only-L \
			cblas blas lapack| sed -e \
			's/^-L//' -e 's/ -L/:/g' -e 's/ //g'):/usr/$(get_libdir)
		atlas_libs = $(pkg-config --libs-only-l \
			cblas blas | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
		lapack_libs = $(pkg-config --libs-only-l \
			lapack | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
		[blas_opt]
			include_dirs = $(pkg-config --cflags-only-I \
			cblas | sed -e 's/^-I//' -e 's/ -I/:/g')
		library_dirs = $(pkg-config --libs-only-L \
		cblas blas | sed -e 's/^-L//' -e 's/ -L/:/g' \
			-e 's/ //g'):/usr/$(get_libdir)
		libraries = $(pkg-config --libs-only-l \
			cblas blas | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
		[lapack_opt]
		library_dirs = $(pkg-config --libs-only-L \
		lapack | sed -e 's/^-L//' -e 's/ -L/:/g' \
			-e 's/ //g'):/usr/$(get_libdir)
		libraries = $(pkg-config --libs-only-l \
		lapack | sed -e 's/^-l//' -e 's/ -l/, /g' -e 's/,.pthread//g')
	EOF

	# copy file into scipy_sandbox
	sage_package scipy_sandbox-20071020.p4 \
		cp "${T}"/site.cfg arpack/site.cfg ; \
		cp "${T}"/site.cfg delaunay/site.cfg

	# unset custom C(XX)FLAGS - this is just a temporary hack
	sage_package ${P} \
		epatch "${FILESDIR}"/${P}-amd64-hack.patch

	# apply patches fixing deprecation warning which interfers with test output
	sage_package ${P} \
		epatch "${FILESDIR}"/${P}-combinat-sets-deprecation.patch
	sage_package moin-1.5.7.p3 \
		epatch "${FILESDIR}"/${P}-moinmoin-sets-deprecation.patch
	sage_package networkx-0.99.p1-fake_really-0.36.p1 \
		epatch "${FILESDIR}"/${P}-networkx-sets-deprecation.patch
	sage_package sqlalchemy-0.4.6.p1 \
		epatch "${FILESDIR}"/${P}-sqlalchemy-sets-deprecation.patch

	# add system path for python modules
	sage_package sage_scripts-${PV} \
		sed -i \
		-e "s:\"\$SAGE_ROOT/local/lib/python\":\"\$SAGE_ROOT/local/$(get_libdir)/python\":g" \
		-e "s:PYTHONPATH=\"\(.*\)\":PYTHONPATH=\"$(python_get_sitedir)\:\1\:\$SAGE_ROOT/local/$(get_libdir)/python/site-packages\":g" \
		-e "/PYTHONHOME=.*/d" \
		sage-env

	# set path to Sage's cython
	sage_package ${P} \
		sed -i "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/':'/usr/$(get_libdir)/python2.6/site-packages/Cython/Includes/':g" \
		setup.py

	# do not download Twisted - TODO: look for another way to solve this
	sage_package sagenb-0.4.8 \
		sed -i "s:twisted>=8.2::g" src/sagenb.egg-info/requires.txt
	sage_package sagenb-0.4.8 \
		sed -i "/install_requires = \['twisted>=8\.2'\],/d" src/setup.py

	# create this directory manually
	mkdir -p "${S}"/local/$(get_libdir)/python2.6/site-packages \
		|| die "mkdir failed"

	# make sure the lib directory exists
	cd "${S}"/local
	[[ -d lib ]] || ln -s $(get_libdir) lib || die "ln failed"

	# make unversioned symbolic link
	cd "${S}"/local/$(get_libdir)
	ln -s python2.6 python || die "ln failed"

	# fix site-packages check
	sage_package ${P} \
		sed -i "s:'%s/lib/python:'%s/$(get_libdir)/python:g" setup.py

	local SPKGS_NEEDING_FIX=( dsage-1.0.1.p0 moin-1.5.7.p3 sagenb-0.4.8
		scipy_sandbox-20071020.p4 sphinx-0.6.3.p3 sqlalchemy-0.4.6.p1 )

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

	# fix include directories
	sage_package ${P} \
		sed -i "s:\$SAGE_LOCAL/include:/usr/include:g" c_lib/SConstruct

	# fix installation paths
	sage_package networkx-0.99.p1-fake_really-0.36.p1 \
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
}

src_install() {
	# remove *.spkg files which will not be needed since sage must be upgraded
	# using portage, this saves about 400 MB
	for i in spkg/standard/*.spkg ; do
		rm $i
		touch $i
	done

	# these files are also not needed
	rm -rf spkg/build/*
	rm -rf tmp

	# remove mercurial directories - these are not needed
	hg_clean

	# TODO: write own installation routine which copies only needed files

	# install files
	emake DESTDIR="${D}/opt" install || die "emake install failed"

	# TODO: handle generated docs
	dodoc README.txt || die "dodoc failed"

	# TODO: create additional desktop files

	# install entries for desktop managers
	doicon "${FILESDIR}"/sage.svg || die "doicon failed"
	domenu "${FILESDIR}"/sage-shell.desktop || die "domenu failed"
# 	domenu "${FILESDIR}"/sage-notebook.desktop || die "domenu failed"

# 	# install entry for documentation if available
# 	use doc && domenu "${FILESDIR}"/sage-documentation.desktop \
# 		|| die "domenu failed"

	sed -i "s:${D}::" "${D}"/opt/bin/sage "${D}"/opt/sage/sage \
		|| die "sed failed"
}

pkg_postinst() {
	# make sure files are correctly setup in the new location by running sage
	# as root. This prevent nasty message to be presented to the user.
	"${SAGE_ROOT}"/sage -c quit
}
