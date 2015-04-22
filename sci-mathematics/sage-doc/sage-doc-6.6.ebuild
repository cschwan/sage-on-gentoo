# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 multiprocessing check-reqs

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

LANGS="ca de en fr hu it pt ru tr"

LICENSE="GPL-2"
SLOT="0"
IUSE="html"

LINGUAS_USEDEP=""
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
	LINGUAS_USEDEP="${LINGUAS_USEDEP}linguas_${X}=,"
done
LINGUAS_USEDEP="${LINGUAS_USEDEP%?}"

RESTRICT="mirror"

# TODO: depend on sage-baselayout (creates sage-main directory) ?
DEPEND="!sci-mathematics/sage-doc-bin
	>=dev-python/docutils-0.12[${PYTHON_USEDEP}]
	sci-mathematics/sage"
RDEPEND="${DEPEND}
	~dev-python/sphinx-1.2.2[${PYTHON_USEDEP}]"

CHECKREQS_DISK_BUILD="5G"
CHECKREQS_DISK_USR="5G"

S="${WORKDIR}/sage-${PV}/src"

REQUIRED_USE="html? ( linguas_en )"

PATCHES=( "${FILESDIR}"/${PN}-6.0-misc.patch
	"${FILESDIR}"/${PN}-6.6-linguas.patch )

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Put singular help file where it is expected
	cp "${WORKDIR}"/Singular/3-1-6/info/singular.hlp doc/
}

python_compile() {
	export SAGE_DOC="${S}"/doc
	export SAGE_SRC="${EPREFIX}"/usr/share/sage/src
	export SAGE_NUM_THREADS=$(makeopts_jobs)
	export SAGE_DOC_MATHJAX=yes
	export VARTEXFONTS="${T}"/fonts
	local mylang
	for lang in ${LANGS} ; do
		use linguas_$lang && mylang+="$lang "
	done
	export LANGUAGES="${mylang}"

	if use html ; then
		${PYTHON} doc/common/builder.py --no-pdf-links all html || die "failed to produce html doc"
	fi
}

python_install() {
	docompress -x /usr/share/doc/sage

	insinto /usr/share/doc/sage
	doins doc/singular.hlp
	for lang in ${LANGS} ; do
		use linguas_$lang && doins -r doc/$lang
	done

	insinto /usr/share/doc/sage/common
	# not installing doc build system
	rm doc/common/builder.py
	rm doc/common/custom-sphinx-build.py
	doins -r doc/common/*

	if use html ; then
		insinto /usr/share/doc/sage/output/html
		doins -r doc/output/html/*
	fi
}

pkg_postinst() {
	if ! use html ; then
		ewarn "You haven't requested the html documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
	fi
}
