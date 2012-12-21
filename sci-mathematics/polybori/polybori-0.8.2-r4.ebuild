# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2:2.7"

inherit base eutils flag-o-matic multilib python scons-utils toolchain-funcs

DESCRIPTION="Polynomials over Boolean Rings"
HOMEPAGE="http://polybori.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV/_rc*/rc}/${P/_rc/rc}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc gd"

# of course polybori has a working set of tests
RESTRICT="mirror"

CDEPEND=">=dev-libs/boost-1.48.0[python]
	dev-python/ipython
	>=sci-libs/m4ri-20090512
	gd? ( media-libs/gd )"
DEPEND="${CDEPEND}
	doc? (
		dev-tex/tex4ht
		app-doc/doxygen
	)"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${PN}-${PV/_rc*/}"

USE_SCONS_TRUE="True"
USE_SCONS_FALSE="False"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.2-python.patch
	"${FILESDIR}"/${PN}-0.8.2-boost-mt.patch
	"${FILESDIR}"/${PN}-0.8.2-otool.patch
	"${FILESDIR}"/${PN}-0.8.2-doc.patch
	"${FILESDIR}"/${PN}-0.8.2-boost1.52.patch
)

pkg_setup() {
	python_set_active_version 2.7
	python_pkg_setup
	export DOT_SAGE="${S}"
}

src_prepare() {
	# make sure external m4ri is used
	rm -r M4RI || die "failed to remove internal copy of m4ri"

	base_src_prepare
	# fix boost_python linking for boost-1.48+ see
	# http://archives.gentoo.org/gentoo-dev/msg_ab39d8366b714ecacfc7fa64cd48ad00.xml
	sed -i "s:boost_python:boost_python-${PYTHON_ABI}:" SConstruct || die "failed to fix boost_python"
}

src_compile(){
	# needed to make polybori linkable
	#append-flags -fPIC

	if [[ ${CHOST} == *-darwin* ]] ; then
		append-flags -fno-strict-aliasing
	fi

	# TODO: handle singular ?

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
		DEVEL_LIB_PREFIX="${ED}"/usr/$(get_libdir)
		PYINSTALLPREFIX="${ED}"$(python_get_sitedir)
		INSTALLDIR="${ED}"/usr/share/polybori
		INSTALL_NAME_DIR="${EPREFIX}"/usr/$(get_libdir)/
		CONFFILE="${ED}"/usr/share/polybori/flags.conf
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

src_test() {
	export PBORI_NOSAGE=1
	ipbori/ipbori -t  || die "PolyBoRi's self-testing feature failed"
}

src_install() {
	escons "${myesconsargs[@]}" install devel-install || die

	# remove incomplete documentation
	if ! use doc ; then
		rm -rf "${ED}"/usr/share/polybori/doc \
			|| die "failed to remove useless documentation"
	fi

	# we only need shared objects elsewhere
	rm "${ED}"/usr/$(get_libdir)/lib*.a \
		|| die "failed to remove static libraries"

	# fixing flags.conf
	sed -i "s:${D}:\/:" "${ED}"/usr/share/polybori/flags.conf || die
}
