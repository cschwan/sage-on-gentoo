# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="readline,sqlite"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 prefix

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vbraun/sage.git"
	EGIT_BRANCH=develop
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	KEYWORDS=""
	S="${WORKDIR}/${P}/pkgs/${PN}_pypi"
else
	PYPI_NO_NORMALIZE=1
	inherit pypi
	KEYWORDS="~amd64 ~amd64-linux ~ppc-macos ~x64-macos"
fi

DESCRIPTION="Math software for abstract and numerical computations"
HOMEPAGE="https://www.sagemath.org"

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
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi

	default
}

git_snapshot_prepare() {
	# specific setup for sage-conf-9999
	einfo "preparing the git snapshot"

	# Get the real README.rst, not just a link.
	# If we don't, a link to a file that doesn't exist is installed - not the file.
	rm README.rst
	cp ../sage-conf/README.rst .

	# get the real setup.cfg otherwise it won't be patched
	rm setup.cfg
	cp ../sage-conf/setup.cfg setup.cfg
}

python_prepare_all() {
	if [[ ${PV} == 9999 ]]; then
		git_snapshot_prepare
	fi

	distutils-r1_python_prepare_all

	# sage on gentoo environment variables
	cp -f "${FILESDIR}"/${PN}.py-9.8 _sage_conf/_conf.py
	eprefixify _sage_conf/_conf.py
	# set the documentation location to the externally provided sage-doc package
	sed -i "s:@GENTOO_PORTAGE_PF@:sage-doc-${PV}:" _sage_conf/_conf.py
	# set lib/lib64 - only useful for GAP_LIB_DIR for now
	sed -i "s:@libdir@:$(get_libdir):g" _sage_conf/_conf.py
	# Fix finding pplpy documentation with intersphinx
	local pplpyver=`equery -q l -F '$name-$fullversion' pplpy:0`
	sed -i "s:@PPLY_DOC_VERS@:${pplpyver}:" _sage_conf/_conf.py
}
