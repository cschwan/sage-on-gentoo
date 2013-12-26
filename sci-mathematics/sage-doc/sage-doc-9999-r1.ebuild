# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_NO_PARALLEL_BUILD="1"

inherit distutils-r1 multiprocessing base versionator

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/sagemath/sage.git"
	EGIT_SOURCEDIR="${WORKDIR}/sage-${PV}"
	inherit git-2
else
	SRC_URI="mirror://sagemath/${PV}.tar.gz -> sage-${PV}.tar.gz"
fi

DESCRIPTION="Documentation, tutorials and help files for Sage"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="${SRC_URI}
	http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/3-1-5/Singular-3-1-5-share.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="html pdf"

RESTRICT="mirror"

# TODO: depend on sage-baselayout (creates sage-main directory) ?
DEPEND=""
RDEPEND=">=dev-python/sphinx-1.1.2"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0-misc.patch
	)

python_prepare_all() {
	distutils-r1_python_prepare_all

	# remove documentation about non-existent dev tools
	rm -rf en/reference/dev
	# remove Makefile
	rm Makefile
	# Put singular help file where it is expected
	cp "${WORKDIR}"/Singular/3-1-5/info/singular.hlp ./

	# fix issue 197
	touch en/__init__.py
	# install missing directories to satisfy builder.py test
	mkdir -p output/doctrees/en/tutorial
	mkdir -p en/tutorial/templates
	mkdir -p en/tutorial/static
	mkdir -p en/reference/templates
	mkdir -p en/reference/static
}

python_compile(){
	export SAGE_DOC="${S}"
	export SAGE_SRC="${S}"/..
	export SAGE_NUM_THREADS=$(makeopts_jobs)

	if use html ; then
		$PYTHON common/builder.py --no-pdf-links all html
	fi
	if use pdf ; then
		$PYTHON common/builder.py all pdf
	fi
}

python_install() {
	docompress -x /usr/share/doc/sage
	# TODO: check if all of these files are needed
	insinto /usr/share/doc/sage
	# not installing doc build system
	rm -rf common
	doins -r *
}

pkg_postinst() {
	if ! use html ; then
		ewarn "You haven't requested the html documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
	fi
}
