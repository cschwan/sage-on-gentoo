# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic multilib python-r1 scons-utils toolchain-funcs

DESCRIPTION="Polynomials over Boolean Rings"
HOMEPAGE="http://polybori.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV/_rc*/rc}/${P/_rc/rc}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE="doc gd"

# of course polybori has a working set of tests
RESTRICT="mirror"

CDEPEND="${PYTHONS_DEPS}
	>=dev-libs/boost-1.52.0[python,${PYTHON_USEDEP}]
	dev-python/ipython[${PYTHON_USEDEP}]
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

src_prepare() {
	python_prepare() {
		# fix boost_python linking for boost-1.48+ see
		# http://archives.gentoo.org/gentoo-dev/msg_ab39d8366b714ecacfc7fa64cd48ad00.xml
		sed -i "s:boost_python:boost_python-${EPYTHON#python}:" SConstruct || die "failed to fix boost_python"
	}

	python_foreach_impl python_prepare
}

src_compile() {
	python_compile() {
		if [[ ${CHOST} == *-darwin* ]] ; then
			append-flags -fno-strict-aliasing
		fi

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
			PYINSTALLPREFIX="${D}"/$(python_get_sitedir)
			INSTALLDIR="${ED}"/usr/share/polybori
			INSTALL_NAME_DIR="${EPREFIX}"/usr/$(get_libdir)/
			CONFFILE="${ED}"/usr/share/polybori/flags.conf
		)

		# extra configuration for macos
		if [[ ${CHOST} == *-darwin* ]] ; then
			myesconsargs+=(
				FORCE_HASH_MAP=True
			)
		fi

		escons "${myesconsargs[@]}" prepare-install prepare-devel || die
	}

	python_foreach_impl python_compile
}

src_test() {
	python_test() {
		export PBORI_NOSAGE=1
		ipbori/ipbori -t  || die "PolyBoRi's self-testing feature failed"
	}

	python_foreach_impl python_test
}

src_install() {
	python_install() {
		escons "${myesconsargs[@]}" install devel-install || die

		# remove incomplete documentation
		if ! use doc ; then
			rm -rf "${ED}"/usr/share/polybori/doc \
				|| die "failed to remove useless documentation"
		fi

		# we only need shared objects elsewhere
		rm "${ED}"/usr/$(get_libdir)/lib*.a \
			|| die "failed to remove static libraries"
	}

	python_foreach_impl python_install
}
