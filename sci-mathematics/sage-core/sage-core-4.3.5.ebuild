# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

NEED_PYTHON=2.6

inherit distutils eutils flag-o-matic sage

MY_P="sage-${PV}"

DESCRIPTION="Sage's core componenents"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

# TODO: add dependencies
DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	# disable --as-needed until all bugs related are fixed
	append-ldflags -Wl,--no-as-needed
}

src_prepare() {
	############################################################################
	# Fixes to Sage's build system
	############################################################################

	# fix build file to make it compile without other Sage componenents
	epatch "${FILESDIR}"/${PN}-4.3.4-site-packages.patch

	# fix paths for various libraries
	sed -i \
		-e "s:SAGE_ROOT +'/local/include/fplll':'/usr/include/fplll':g" \
		-e "s:SAGE_ROOT + \"/local/include/fplll/fplll.h\":\"/usr/include/fplll/fplll.h\":g" \
		-e "s:SAGE_ROOT + '/local/include/gmp.h':'/usr/include/gmp.h':g" \
		-e "s:SAGE_ROOT + \"/local/include/ecm.h\":\"/usr/include/ecm.h\":g" \
		-e "s:SAGE_ROOT + \"/local/include/png.h\":\"/usr/include/png.h\":g" \
		-e "s:SAGE_ROOT + '/local/include/ratpoints.h':'/usr/include/ratpoints.h':g" \
		-e "s:SAGE_ROOT + \"/local/include/symmetrica/def.h\":\"/usr/include/symmetrica/def.h\":g" \
		-e "s:SAGE_ROOT+'/local/include/FLINT/':'/usr/include/FLINT/':g" \
		-e "s:SAGE_ROOT + \"/local/include/FLINT/flint.h\":\"/usr/include/FLINT/flint.h\":g" \
		-e "s:SAGE_ROOT + '/local/include/FLINT/flint.h':'/usr/include/FLINT/flint.h':g" \
		-e "s:SAGE_ROOT + \"/local/include/pynac/ginac.h\":\"/usr/include/pynac/ginac.h\":g" \
		-e "s:SAGE_ROOT+'/local/lib/python/site-packages/numpy/core/include':'/usr/lib/python2.6/site-packages/numpy/core/include':g" \
		-e "s:SAGE_LOCAL + \"/share/polybori/flags.conf\":\"/usr/share/polybori/flags.conf\":g" \
		-e "s:SAGE_ROOT+'/local/include/cudd':'/usr/include/cudd':g" \
		-e "s:SAGE_ROOT+'/local/include/polybori':'/usr/include/polybori':g" \
		-e "s:SAGE_ROOT+'/local/include/polybori/groebner':'/usr/include/polybori/groebner':g" \
		-e "s:SAGE_ROOT + \"/local/include/polybori/polybori.h\":\"/usr/include/polybori/polybori.h\":g" \
		module_list.py || die "sed failed"

	# set path to system Cython
	sed -i "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/':'/usr/$(get_libdir)/python2.6/site-packages/Cython/Includes/':g" \
		setup.py || die "sed failed"

	# fix include paths
	sed -i \
		-e "s:'%s/include/csage'%SAGE_LOCAL:'/usr/include/csage':g" \
		-e "s:'%s/sage/sage/ext'%SAGE_DEVEL:'sage/ext':g" \
		setup.py || die "sed failed" 
	sed -i "s:'%s/local/include/csage/'%SAGE_ROOT:'/usr/include/csage/':g" \
		sage/misc/cython.py || die "sed failed"

	# TODO: more include paths in cython.py
	# TODO: grep for files containing "devel/sage" and fix paths

	# rebuild in place
	sed -i "s:SAGE_DEVEL + 'sage/sage/ext/interpreters':'sage/ext/interpreters':g" \
		setup.py || die "sed failed"

	# fix missing libraries needed with "--as-needed"
	epatch "${FILESDIR}"/${PN}-4.3.3-fix-undefined-symbols.patch

	# TODO: At least one more patch needed: devel/sage/sage/misc/misc.py breaks

	# TODO: why does Sage fail with commentator ?

	# unset custom C(XX)FLAGS - this is just a temporary hack
	epatch "${FILESDIR}"/${PN}-4.3-amd64-hack.patch

	############################################################################
	# Fixes to Sage itself
	############################################################################

	# run maxima with ecl
	sed -i \
		-e "s:maxima-noreadline:maxima -l ecl:g" \
		-e "s:maxima --very-quiet:maxima -l ecl --very-quiet:g" \
		sage/interfaces/maxima.py || die "sed failed"

	# Ticket #7803:
	# apply patches fixing deprecation warning which interfers with test output
	epatch "${FILESDIR}"/${PN}-4.3.3-combinat-sets-deprecation.patch

	# use delaunay from matplotlib (see ticket #6946)
	epatch "${FILESDIR}"/${PN}-4.3.3-delaunay-from-matplotlib.patch

	# use arpack from scipy (see also scipy ticket #231)
	epatch "${FILESDIR}"/${PN}-4.3.3-arpack-from-scipy.patch

	# do not forget to run distutils
	distutils_src_prepare
}

src_configure() {
	# set Sage's version string
	export SAGE_VERSION=${PV}

	# these variables are still needed; remove them once Singular is removed
	# from Sage
	export SAGE_ROOT
	export SAGE_LOCAL

	# files are not built unless they are touched
	find sage -name "*pyx" -exec touch '{}' \; || die "find failed"
}

# TODO: some files are not installed
# TODO: edit Sage's relocation code
