# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION=4.3.2
SAGE_PACKAGE=${PN}-0.6.3-${PV}

NEED_PYTHON=2.5

inherit eutils python sage versionator

DESCRIPTION="Polynomials over Boolean Rings"
HOMEPAGE="http://polybori.sourceforge.net/"
# SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${PN}-$(replace_version_separator 2 '-').tar.gz -> ${P}.tar.gz"

RESTRICT="mirror test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gd sage"

# TODO: clean up this file

CDEPEND=">=dev-libs/boost-1.34.1[python]
	dev-python/ipython
	gd? ( media-libs/gd )"
DEPEND="${CDEPEND}
	>=dev-util/scons-0.98
	>=sci-libs/m4ri-20090512
	doc? (
		dev-tex/tex4ht
		app-doc/doxygen
	)"
RDEPEND="${CDEPEND}"

S="${WORKDIR}"/${SAGE_PACKAGE}/src/${PN}-0.6

src_prepare(){
	if use sage ; then
		# TODO: This should not be done; find a better solution
		cp "${FILESDIR}"/PyPolyBoRi.py pyroot/polybori/PyPolyBoRi.py \
			|| die "cp failed"

		# TODO: Sage needs this file but we should find a better solution,
		# maybe dev-util/pkgconfig ?
		epatch "${FILESDIR}"/${P}-save-flags.patch
	fi

	# make sure polybori does not use its own version of m4ri
	sed -i "s:external_m4ri = False:external_m4ri = True:g" SConstruct
}

src_compile(){
	if use doc ; then
	    DOC="True"
	else
	    DOC="False"
	fi

	# TODO: handle singular

	# store all parameters for scons in a bash array
	PARAMS=( CFLAGS=${CFLAGS} CCFLAGS= CXXFLAGS=${CXXFLAGS} \
		LINKFLAGS=${LDFLAGS} HAVE_HEVEA=False HAVE_L2H=False \
		HAVE_TEX4HT=${DOC} HAVE_DOXYGEN=${DOC} HAVE_PYDOC=${DOC} \
		MANDIR="${D}"/usr/share/man PREFIX="${D}"/usr \
		PYINSTALLPREFIX="${D}"$(python_get_sitedir) \
		INSTALLDIR="${D}"/usr/share/polybori )

	scons "${PARAMS[@]}" prepare-install prepare-devel || die "scons failed"
}

src_install() {
	scons "${PARAMS[@]}" install devel-install || die "scons failed"

	# remove incomplete documentation
	use doc || rm -rf "${D}"/usr/share/polybori/doc
}

src_test() {
	# TODO: test programs do net get compiled
	testsuite/execsuite
}
