# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4,3_5} )

inherit distutils-r1 toolchain-funcs eutils

DESCRIPTION="Python package for convex optimization"
HOMEPAGE="http://cvxopt.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
CVXOPT_USE="dsdp fftw glpk gsl"
IUSE="doc +dsdp examples fftw +glpk gsl"

RDEPEND="
	virtual/blas
	virtual/cblas
	virtual/lapack
	sci-libs/cholmod:0=
	sci-libs/umfpack:0=
	dsdp? ( sci-libs/dsdp:0= )
	fftw? ( sci-libs/fftw:3.0= )
	glpk? ( sci-mathematics/glpk:0= )
	gsl? ( sci-libs/gsl:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )"

python_prepare_all(){
	pkg_lib() {
		local pkg=$(echo $1 | tr '[:lower:]' '[:upper:]')
		local libs="$($(tc-getPKG_CONFIG) --libs-only-l $1 | \
			sed -e 's:[ ]-l*\(pthread\|m\)\([ ]\|$\)::g' -e 's:[ ]*$::' | \
			tr ' ' '\n' | sort -u | sed -e "s:^-l\(.*\):'\1':g" | \
			tr '\n' ',' | sed -e 's:,$::')"
		local libdir="$($(tc-getPKG_CONFIG) --libs-only-L $1 | \
			sed -e 's:[ ]*$::' | \
			tr ' ' '\n' | sort -u | sed -e "s:^-L\(.*\):'\1':g" | \
			tr '\n' ',' | sed -e 's:,$::')"
		local incdir="$($(tc-getPKG_CONFIG) --cflags-only-I $1 | \
			sed -e 's:[ ]*$::' | \
			tr ' ' '\n' | sort -u | sed -e "s:^-L\(.*\):'\1':g" | \
			tr '\n' ',' | sed -e 's:,$::')"
		sed -i \
			-e "/${pkg}_LIB[ ]*=/s:\(.*[ ]*=[ ]*\[\).*${1}.*:\1${libs}\]:" \
			-e "s:\(${pkg}_INC_DIR[ ]*=\).*$:\1 ${incdir}:" \
			-e "s:\[ BLAS_LIB_DIR \]:\[ ${libdir} \]:g" \
			setup.py || die
	}

	pkg_lib blas
	pkg_lib lapack

	distutils-r1_python_prepare_all
}

python_configure() {
	for option in ${CVXOPT_USE} ; do
		if use ${option} ; then
			export CVXOPT_BUILD_${option^^}=1
			export CVXOPT_${option^^}_INC_DIR="${EPREFIX}/usr/include"
			export CVXOPT_${option^^}_LIB_DIR=''
		fi
	done
	export SUITESPARSE_EXT_LIB=1
	export SUITESPARSE_INC_DIR="${EPREFIX}/usr/include"
	export SUITESPARSE_LIB_DIR=''
}

python_compile_all() {
	use doc && export VARTEXFONTS="${T}/fonts" && emake -C doc -B html
}

python_test() {
	cd examples/doc/chap8
	"${EPYTHON}" lp.py || die
}

python_install_all() {
	use doc && HTML_DOCS=( doc/build/html/. )
	insinto /usr/share/doc/${PF}
	use examples && doins -r examples
	distutils-r1_python_install_all
}
