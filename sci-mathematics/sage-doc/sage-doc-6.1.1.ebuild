# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit base versionator

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

# for now no html or pdf
#BPV="6.0"
BPV="${PV}"
MY_P_HTML="sage-${BPV}-doc-html"
MY_P_PDF="sage-${BPV}-doc-pdf"

DESCRIPTION="Documentation, tutorials and help files for Sage"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="${SRC_URI}
	http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/3-1-5/Singular-3-1-5-share.tar.gz
	html? ( mirror://sagemathdoc/${MY_P_HTML}.tar.bz2 -> sage-doc-html-${BPV}.tar.bz2 )
	pdf? ( mirror://sagemathdoc/${MY_P_PDF}.tar.bz2 -> sage-doc-pdf-${BPV}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
IUSE="html pdf"

RESTRICT="mirror"

# TODO: depend on sage-baselayout (creates sage-main directory) ?
DEPEND=""
RDEPEND=">=dev-python/sphinx-1.1.2"

S="${WORKDIR}/sage-${PV}/src/doc"

PATCHES=( "${FILESDIR}"/${PN}-6.0-misc.patch )

src_prepare() {
	base_src_prepare

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

	if use html ; then
		mkdir -p output/html
		cp -r "${WORKDIR}"/${MY_P_HTML}/* output/html/
		# issue 197
		touch output/html/en/__init__.py
	fi

	if use pdf ; then
		mkdir -p output/pdf
		cp -r "${WORKDIR}"/${MY_P_PDF}/* output/pdf/
	fi
}

src_install() {
	docompress -x /usr/share/doc/sage
	# TODO: check if all of these files are needed
	insinto /usr/share/doc/sage
	doins -r *
}

pkg_postinst() {
	if ! use html ; then
		ewarn "You haven't requested the html documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
	fi
}
