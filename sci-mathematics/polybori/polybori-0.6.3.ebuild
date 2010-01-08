# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

NEED_PYTHON=2.5

inherit eutils python versionator

DESCRIPTION="Polynomials over Boolean Rings"
HOMEPAGE="http://polybori.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${PN}-$(replace_version_separator 2 '-').tar.gz -> ${P}.tar.gz"

RESTRICT="mirror test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc gd sage singular"

# TODO: clean up this file

CDEPEND=">=dev-libs/boost-1.34.1[python]
	dev-python/ipython
	gd? ( media-libs/gd )
	singular? ( sci-mathematics/singular )"
DEPEND="${CDEPEND}
	>=dev-util/scons-0.98
	>=sci-libs/m4ri-20090512
	doc? (
		dev-tex/tex4ht
		app-doc/doxygen
	)"
RDEPEND=""

S="${WORKDIR}/${PN}-$(get_version_component_range 1-2)"

src_prepare(){
	if use sage ; then
		# TODO: This should not be done; find a better solution
		cp "${FILESDIR}/PyPolyBoRi.py" "${S}/pyroot/polybori/"

		# TODO: Sage needs this file but we should find a better solution,
		# maybe dev-util/pkgconfig ?
		epatch "${FILESDIR}/${P}-save-flags.patch"
	fi

	# make sure polybori does not use its own version of m4ri
	sed -i "s:external_m4ri = False:external_m4ri = True:g" SConstruct
}

src_compile(){
	# hevea and l2h are deprecated and will be removed so we focus on tex4ht
	# tried to summarize all the options in a variable but it didn't parse correctly
	if use doc ; then
	    DOC="True"
	else
	    DOC="False"
	fi

	# TODO: handle singular

	scons CFLAGS="${CFLAGS}" \
		CCFLAGS="" \
		CXXFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		HAVE_HEVEA="False" \
		HAVE_L2H="False" \
		HAVE_TEX4HT="${DOC}" \
		HAVE_DOXYGEN="${DOC}" \
		HAVE_PYDOC="${DOC}" \
		MANDIR="${D}/usr/share/man" prepare-install prepare-devel \
		|| die "scons prepare-install prepare-devel failed"
}

src_install() {
	mkdir -p "${D}"

	scons CFLAGS="${CFLAGS}" \
		CCFLAGS="" \
		CXXFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		HAVE_HEVEA="False" \
		HAVE_L2H="False" \
		HAVE_TEX4HT="${DOC}" \
		HAVE_DOXYGEN="${DOC}" \
		HAVE_PYDOC="${DOC}" \
		PREFIX="${D}/usr" \
		MANDIR="${D}/usr/share/man" \
		PYINSTALLPREFIX="${D}$(python_get_sitedir)" \
		INSTALLDIR="${D}/usr/share/polybori" install devel-install \
		|| die "scons install devel-install failed"

	# remove incomplete documentation
	use doc || rm -rf "${D}"/usr/share/polybori/doc
}

src_test() {
	# TODO: test programs do net get compiled
	testsuite/execsuite
}
