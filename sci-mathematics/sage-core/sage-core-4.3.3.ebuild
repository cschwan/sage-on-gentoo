# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

NEED_PYTHON=2.6

SAGE_VERSION=${PV}
SAGE_PACKAGE=sage-${PV}

inherit distutils eutils sage

# TODO: write description
DESCRIPTION="Sage's core componenents"
# HOMEPAGE=""
# SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	# run maxima with ecl
	sed -i "s:maxima-noreadline:maxima -l ecl:g" sage/interfaces/maxima.py \
		|| die "sed failed"

	# fix missing libraries needed with "--as-needed"
	epatch "${FILESDIR}"/${P}-fix-undefined-symbols.patch

	# TODO: At least one more patch needed: devel/sage/sage/misc/misc.py breaks

	# TODO: why does Sage fail with commentator ?
# 	# disable linbox commentator which is too verbose and confuses Sage
# 	sage_package ${P} \
# 		epatch "${FILESDIR}"/${PN}-4.3.2-disable-linbox-commentator.patch

	# TODO: Are these needed ?
	sed -i \
		-e "s:SAGE_ROOT +'/local/include/fplll':'/usr/include/fplll':g" \
		-e "s:SAGE_ROOT + \"/local/include/ecm.h\":\"/usr/include/ecm.h\":g" \
		-e "s:SAGE_ROOT + \"/local/include/png.h\":\"/usr/include/png.h\":g" \
		-e "s:SAGE_ROOT + \"/local/include/symmetrica/def.h\":\"/usr/include/symmetrica/def.h\":g" \
		module_list.py || die "sed failed"

	# TODO: -e "s:SAGE_ROOT + \"/local/include/fplll/fplll.h\":\"\":g" \
	# this file does not exist

	# fix paths for flint, pynac/ginac, numpy and polybori
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
		module_list.py || die "sed failed"

	# remove csage which is built elsewhere
	epatch "${FILESDIR}"/${P}-remove-csage.patch
# 	epatch "${FILESDIR}"/${P}-remove-csage-2.patch

	# fix csage include
	sed -i "s:'%s/include/csage'%SAGE_LOCAL:'/usr/include/csage':g" setup.py \
		|| die "sed failed"
	sed -i "s:'%s/local/include/csage/'%SAGE_ROOT:'/usr/include/csage/':g" \
		sage/misc/cython.py || die "sed failed"

	# TODO: maybe there are more paths to fix in sage/misc/cython.py

	# remove csage files which are not needed
	rm -rf c_lib || die "rm failed"

	# unset custom C(XX)FLAGS - this is just a temporary hack
	epatch "${FILESDIR}"/${P}-amd64-hack.patch

	# set path to Sage's cython
	sed -i "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/':'/usr/$(get_libdir)/python2.6/site-packages/Cython/Includes/':g" \
		setup.py || die "sed failed"

	# fix site-packages check
	sed -i "s:'%s/lib/python:'%s/$(get_libdir)/python:g" setup.py \
		|| die "sed failed"

	# Ticket #7803:
	# apply patches fixing deprecation warning which interfers with test output
	epatch "${FILESDIR}"/${P}-combinat-sets-deprecation.patch

	# use delaunay from matplotlib (see ticket #6946)
	epatch "${FILESDIR}"/${P}-delaunay-from-matplotlib.patch

	# use arpack from scipy (see also scipy ticket #231)
	epatch "${FILESDIR}"/${P}-arpack-from-scipy.patch

	#
	distutils_src_prepare
}

src_configure() {
	export SAGE_ROOT="${D}${SAGE_ROOT}"
	export SAGE_LOCAL="${D}${SAGE_LOCAL}"

	cd sage
	find . -name *pyx -exec touch '{}' \;

	mkdir -p "${SAGE_LOCAL}"/lib/python/site-packages
}
