# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.7"

inherit eutils flag-o-matic multilib python scons-utils toolchain-funcs versionator

DESCRIPTION="Polynomials over Boolean Rings"
HOMEPAGE="http://polybori.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc gd sage"

# polybori does not have a working set of tests
RESTRICT="mirror test"

CDEPEND=">=dev-libs/boost-1.34.1[python]
	dev-python/ipython
	gd? ( media-libs/gd )"
DEPEND="${CDEPEND}
	>=sci-libs/m4ri-20090512
	doc? (
		dev-tex/tex4ht
		app-doc/doxygen
	)"
RDEPEND="${CDEPEND}"

S="${WORKDIR}"/${PN}-$(get_version_component_range 1-2)

USE_SCONS_TRUE="True"
USE_SCONS_FALSE="False"

pkg_setup() {
	python_set_active_version 2.7
	python_pkg_setup

	export DOT_SAGE="${S}"

	if [[ ${CHOST} == *-darwin* ]] ; then
		append-flags -fno-strict-aliasing
	fi
}

src_prepare() {
	if use sage ; then
		# TODO: This should not be done; find a better solution
		cp "${FILESDIR}"/PyPolyBoRi.py pyroot/polybori/PyPolyBoRi.py \
			|| die "cp failed"
	fi

	# make sure external m4ri is used
	rm -r M4RI || die "failed to remove internal copy of m4ri"

	# backporting improved build system from polybori 0.8
	epatch "${FILESDIR}"/${PN}-0.7.1-build-0.8-backport.patch
	# patch for compatibility with >=m4ri-20100817
	epatch "${FILESDIR}"/${PN}-0.7.1-m4ri-twopow.patch
	epatch "${FILESDIR}"/${PN}-m4ri20100817.patch
	epatch "${FILESDIR}"/${PN}-0.7.1-local-paths.patch
	epatch "${FILESDIR}"/${PN}-0.7.1-environ.patch
	epatch "${FILESDIR}"/${PN}-0.7.1-gd_libs.patch
}

src_compile(){
	# store all parameters for scons in a bash array
	myesconsargs=(
		CC=$(tc-getCC)
		CXX=$(tc-getCXX)
		CFLAGS=${CFLAGS}
		CCFLAGS=""
		CXXFLAGS=${CXXFLAGS}
		LINKFLAGS=${LDFLAGS}
		HAVE_HEVEA=False
		HAVE_L2H=False
		$(use_scons doc HAVE_TEX4HT)
		$(use_scons doc HAVE_DOXYGEN)
		$(use_scons doc HAVE_PYDOC)
		MANDIR="${ED}"/usr/share/man
		PREFIX="${ED}"/usr
		PYINSTALLPREFIX="${ED}"$(python_get_sitedir)
		INSTALLDIR="${ED}"/usr/share/polybori
		CONFFILE="${ED}"/usr/share/polybori/flags.conf
		DEVEL_LIB_PREFIX=${ED}/usr/$(get_libdir)/
		INSTALL_NAME_DIR=${ED}/usr/$(get_libdir)/
		$(use_scons !sage HAVE_PYTHON_EXTENSION)
		$(use_scons sage EXTERNAL_PYTHON_EXTENSION)
	)

	# extra configuration for macos
	# FIXME: don't know how to deal properly with versionned libraries with install_name so dropping it.
	if [[ ${CHOST} == *-darwin* ]] ; then
		myesconsargs+=(
			FORCE_HASH_MAP=True
			SHLIBVERSIONING=False
		)
	fi

	escons "${myesconsargs[@]}" prepare-install prepare-devel || die
}

src_install() {
	escons "${myesconsargs[@]}" install devel-install || die

	# remove incomplete documentation
	if ! use doc ; then
		rm -rf "${ED}"/usr/share/polybori/doc \
			|| die "failed to remove useless documentation"
	fi

	# fixing flags.conf
	sed -i "s:${D}:\/:" "${ED}"/usr/share/polybori/flags.conf
}
