# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_DEPEND="2:2.7:2.7"

inherit mercurial distutils

DESCRIPTION="Python interface for polymake"
HOMEPAGE="https://bitbucket.org/matroid/sage_matroids"
EHG_REPO_URI="http://bitbucket.org/matroid/sage_matroids"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-mathematics/sage
	"
RDEPEND="${DEPEND}"

pkg_setup() {
	# Sage now will only works with python 2.7.*
	python_set_active_version 2.7
	python_pkg_setup
}

src_prepare(){
	epatch "${FILESDIR}"/setup.py.patch
	epatch "${FILESDIR}"/module_list.py.patch

	# match the sage ebuild from here
	# fix cython path
	sed -i \
		-e "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/':'${EPREFIX}$(python_get_sitedir)/Cython/Includes/':g" \
		-e "s:SAGE_LOCAL + '/lib/python/site-packages/Cython/Includes/Deprecated/':'${EPREFIX}$(python_get_sitedir)/Cython/Includes/Deprecated/':g" \
		setup.py

	# patch SAGE_LOCAL
	sed -i "s:SAGE_LOCAL = SAGE_ROOT + '/local':SAGE_LOCAL = os.environ['SAGE_LOCAL']:g" \
		module_list.py

	distutils_src_prepare
}

src_configure() {
	export SAGE_LOCAL="${EPREFIX}"/usr/
	export SAGE_ROOT="${EPREFIX}"/usr/share/sage
	export SAGE_VERSION=${PV}
	export DOT_SAGE="${S}"

	# files are not built unless they are touched
	find sage -name "*pyx" -exec touch '{}' \; \
		|| die "failed to touch *pyx files"
}

src_install() {
# 	distutils-r1_src_install
	distutils_src_install

	# install sources needed for testing and compiling of cython files and spyx files
	find sage/matroids ! \( -name "*.py" -o -name "*.pyx" -o -name "*.pxd" -o \
		-name "*.pxi" -o -name "*.h" \) -type f -delete \
		|| die "failed to remove non-testable sources"

	insinto /usr/share/sage/devel/sage-main/sage
	doins -r sage/matroids || die
}
