# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 prefix git-r3

EGIT_REPO_URI="https://github.com/vbraun/sage.git"
EGIT_BRANCH=develop
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
KEYWORDS=""

DESCRIPTION="Math software for abstract and numerical computations"
HOMEPAGE="https://www.sagemath.org"
S="${WORKDIR}/${P}/pkgs/${PN}_pypi"

LICENSE="GPL-2"
SLOT="0"

# No real tests here in spite of QA warnings.
RESTRICT="test mirror"

# pplpy needs to be installed to get documentation folder right :(
DEPEND="~dev-python/pplpy-0.8.7:=[doc,${PYTHON_USEDEP}]"
BDEPEND="app-portage/gentoolkit"
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-9.7.patch"
)

src_unpack() {
	git-r3_src_unpack

	default
}

python_prepare_all() {
	distutils-r1_python_prepare_all

	# sage on gentoo environment variables
	cp -f "${FILESDIR}"/${PN}.py.in-9.7 sage_conf.py
	eprefixify sage_conf.py
	# set the documentation location to the externally provided sage-doc package
	sed -i "s:@GENTOO_PORTAGE_PF@:sage-doc-${PV}:" sage_conf.py
		# Fix finding pplpy documentation with intersphinx
	local pplpyver=`equery -q l -F '$name-$fullversion' pplpy:0`
	sed -i "s:@PPLY_DOC_VERS@:${pplpyver}:" sage_conf.py
}
