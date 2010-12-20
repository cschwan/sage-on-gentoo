# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.6"

inherit eutils flag-o-matic multilib python versionator

DESCRIPTION="Polynomials over Boolean Rings"
HOMEPAGE="http://polybori.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${PN}-$(replace_version_separator 2 '-').tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc gd sage"

# polybori does not have a working set of tests
RESTRICT="mirror test"

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

S="${WORKDIR}"/${PN}-$(get_version_component_range 1-2)

src_prepare(){
	if use sage ; then
		# TODO: This should not be done; find a better solution
		cp "${FILESDIR}"/PyPolyBoRi.py pyroot/polybori/PyPolyBoRi.py \
			|| die "cp failed"

		# TODO: Sage needs this file but we should find a better solution,
		# maybe dev-util/pkgconfig ?
		epatch "${FILESDIR}"/${PN}-0.6.4-save-flags.patch
	fi
}

src_compile(){
	# needed to make polybori linkable
	append-flags -fPIC

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
		MANDIR="${ED}"/usr/share/man PREFIX="${ED}"/usr \
		PYINSTALLPREFIX="${ED}"$(python_get_sitedir) \
		INSTALLDIR="${ED}"/usr/share/polybori \
		LIBDIRPREFIX="${ED}"/usr/$(get_libdir) )

	scons "${MAKEOPTS}" "${PARAMS[@]}" prepare-install prepare-devel || die
}

src_install() {
	scons "${MAKEOPTS}" "${PARAMS[@]}" install devel-install || die

	# remove incomplete documentation
	if ! use doc ; then
		rm -rf "${ED}"/usr/share/polybori/doc \
			|| die "failed to remove useless documentation"
	fi

	# TODO: fix installation directory for libraries

	# circumvents problem of random SIGABRT in Sage on amd64
	rm "${ED}"/usr/lib/lib*.so* \
		|| die "failed to remove shared objects"
}
