# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_NO_PARALLEL_BUILD="1"

inherit distutils-r1 multiprocessing versionator

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/sagemath/sage.git"
	EGIT_BRANCH=develop
	EGIT_SOURCEDIR="${WORKDIR}/sage-${PV}"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="mirror://sagemath/${PV}.tar.gz -> sage-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Documentation, tutorials and help files for Sage"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="${SRC_URI}
	http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/3-1-6/Singular-3-1-6-share.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="html pdf"

RESTRICT="mirror"

# TODO: depend on sage-baselayout (creates sage-main directory) ?
DEPEND="|| ( <dev-python/docutils-0.10[${PYTHON_USEDEP}] >dev-python/docutils-0.10[${PYTHON_USEDEP}] )
	sci-mathematics/sage
	pdf? ( dev-texlive/texlive-langcyrillic )"
RDEPEND="${DEPEND}
	>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
	pdf? ( dev-texlive/texlive-langcyrillic
		dev-texlive/texlive-langfrench
		dev-texlive/texlive-langportuguese
		dev-texlive/texlive-langgerman )"

S="${WORKDIR}/sage-${PV}/src"

PATCHES=( "${FILESDIR}"/${PN}-6.0-misc.patch
	"${FILESDIR}"/${PN}-dev.patch
	"${FILESDIR}"/${PN}-6.2-seealso.patch
	"${FILESDIR}"/${PN}-6.2-sphinx.patch
	"${FILESDIR}"/${PN}-6.2-favicon.patch )

python_prepare_all() {
	distutils-r1_python_prepare_all

	cd doc
	# remove dev tools
	rm -rf en/reference/dev

	# Put singular help file where it is expected
	cp "${WORKDIR}"/Singular/3-1-6/info/singular.hlp ./

	# fix issue 197
	touch en/__init__.py
	# install missing directories to satisfy builder.py test
	mkdir -p output/doctrees/en/tutorial
	mkdir -p en/tutorial/templates
	mkdir -p en/tutorial/static
	mkdir -p en/reference/templates
	mkdir -p en/reference/static
}

python_compile() {
	export SAGE_DOC="${S}"/doc
	export SAGE_SRC="${S}"
	export SAGE_NUM_THREADS=$(makeopts_jobs)
	export SAGE_DOC_MATHJAX=yes
	export VARTEXFONTS="${T}"/fonts

	if use html ; then
		${PYTHON} doc/common/builder.py --no-pdf-links all html || die "failed to produce html doc"
		# issue #197
		touch doc/output/html/en/__init__.py
	fi
	if use pdf ; then
		export MAKE=make
		${PYTHON} doc/common/builder.py all pdf || die "failed to produce pdf doc"
	fi
}

python_install() {
	docompress -x /usr/share/doc/sage
	# TODO: check if all of these files are needed
	insinto /usr/share/doc/sage
	# not installing doc build system
	rm doc/common/builder.py
	rm doc/common/custom-sphinx-build.py
	doins -r doc/*
}

pkg_postinst() {
	if ! use html ; then
		ewarn "You haven't requested the html documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
	fi
}
