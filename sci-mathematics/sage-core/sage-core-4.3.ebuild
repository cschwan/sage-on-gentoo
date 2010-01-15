# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

NEED_PYTHON=2.6

SAGE_VERSION=${PV}
SAGE_PACKAGE=sage-${PV}

inherit distutils eutils sage

# TODO: write description
DESCRIPTION=""
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
	# fix command for calling maxima
	sage_package ${P} \
		sed -i "s:maxima-noreadline:maxima:g" sage/interfaces/maxima.py

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

	# unset custom C(XX)FLAGS on amd64 - this is just a temporary hack
	use amd64 && epatch "${FILESDIR}/${P}-amd64-hack.patch"

	# fix importing of deprecated sets module
	epatch "${FILESDIR}/${P}-fix-deprecation-warning.patch"

	# set path to Sage's cython
	sed -i "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/':'/usr/$(get_libdir)/python2.6/site-packages/Cython/Includes/':g" \
		setup.py || die "sed failed"

	# fix site-packages check
	sed -i "s:'%s/lib/python:'%s/$(get_libdir)/python:g" setup.py \
		|| die "sed failed"
}

src_configure() {
	export SAGE_ROOT
	export SAGE_LOCAL

	cd sage
	find . -name *pyx -exec touch '{}' \;

# 	mkdir -p "${SAGE_LOCAL}"/lib/python/site-packages
}
