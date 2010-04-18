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
DEPEND="~sci-mathematics/sage-base-${PV}
	~sci-mathematics/sage-scripts-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	# disable --as-needed until all bugs related are fixed
	append-ldflags -Wl,--no-as-needed

	# switch to lapack-atlas as some dependencies of sage are linked against it
	# specifically because of clapack.
	OLD_IMPLEM=$(eselect lapack show | cut -d: -f2)
	einfo "Switching to lapack-atlas with eselect."
	eselect lapack set atlas
}

src_prepare() {
	############################################################################
	# Fixes to Sage's build system
	############################################################################

	# Fix compilation issues on amd64 reported by Steve Trogdon
	if use amd64 ; then
		append-flags -fno-strict-aliasing
	fi

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
		-e "s:SAGE_ROOT +'/local/include/singular':'${SAGE_LOCAL}/include/singular':g" \
		-e "s:SAGE_ROOT + \"/local/include/libsingular.h\":\"${SAGE_LOCAL}/include/libsingular.h\":g" \
		module_list.py || die "sed failed"

	# set path to system Cython
	sed -i "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/':'/usr/$(get_libdir)/python2.6/site-packages/Cython/Includes/':g" \
		setup.py || die "sed failed"

	# TODO: once Singular is installed to standard dirs, remove the following
	sed -i \
		-e "s:m.library_dirs += \['%s/lib' % SAGE_LOCAL\]:m.library_dirs += \['${SAGE_LOCAL}/$(get_libdir)','%s/lib' % SAGE_LOCAL\]:g" \
		-e "s:include_dirs = \['%s/include'%SAGE_LOCAL:include_dirs = \['${SAGE_LOCAL}/include','%s/include'%SAGE_LOCAL:g" \
		setup.py

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

	############################################################################
	# Fixes to Sage itself
	############################################################################

	# run maxima with ecl
	sed -i \
		-e "s:maxima-noreadline:maxima -l ecl:g" \
		-e "s:maxima --very-quiet:maxima -l ecl --very-quiet:g" \
		sage/interfaces/maxima.py || die "sed failed"

	# TODO: Did not work (?), remove it
# 	# Fix gap invocation of sage.g - hopefully fixing Marek's problem.
# 	sage_package ${P} \
# 		sed -i "s:DB_HOME = \"%s/data/\"%SAGE_ROOT:DB_HOME = \"${SAGE_ROOT}/data/\":g" \
# 		sage/interfaces/gap.py

	# Ticket #7803:
	# apply patches fixing deprecation warning which interfers with test output
	epatch "${FILESDIR}"/${PN}-4.3.3-combinat-sets-deprecation.patch

	# use delaunay from matplotlib (see ticket #6946)
	epatch "${FILESDIR}"/${PN}-4.3.3-delaunay-from-matplotlib.patch

	# use arpack from scipy (see also scipy ticket #231)
	epatch "${FILESDIR}"/${PN}-4.3.3-arpack-from-scipy.patch

	# upgrade networkx to 1.0.1 (see Trac #7608)
	epatch "${FILESDIR}"/${P}-upgrade-networkx.patch.bz2

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

src_install() {
	# TODO: check if this works - copies files to Sage's devel dir
	# TODO: check if this is needed only for testing
	insinto "${SAGE_ROOT}"/devel/sage-main
	doins -r sage || die "doins failed"

	# 
	distutils_src_install
}

pkg_postinst() {
	# Restoring the original lapack settings.
	einfo "Restoring your original lapack settings with eselect"
	eselect lapack set ${OLD_IMPLEM}
}

# TODO: some files are not installed
# TODO: edit Sage's relocation code
