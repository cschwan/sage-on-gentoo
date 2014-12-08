# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit base

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

MY_P_HTML="sage-${PV}-doc-html"
MY_P_PDF="sage-${PV}-doc-pdf"

DESCRIPTION="Documentation, tutorials and help files for Sage (pre-built html/pdf)"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="mirror://sagemath/${PV}.tar.gz -> sage-${PV}.tar.gz
	http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/3-1-6/Singular-3-1-6-share.tar.gz
	html? ( mirror://sagemathdoc/${MY_P_HTML}.tar.bz2 )
	pdf? ( mirror://sagemathdoc/${MY_P_PDF}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
IUSE="+html pdf"

RESTRICT="mirror"

DEPEND="!sci-mathematics/sage-doc"
RDEPEND="${DEPEND}
	>=dev-python/sphinx-1.2.2"

S="${WORKDIR}/sage-${PV}/src/doc"

PATCHES=( "${FILESDIR}"/${PN}-6.0-misc.patch
	"${FILESDIR}"/${PN}-dev.patch )

src_prepare() {
	base_src_prepare

	# remove documentation about non-existent dev tools
	rm -rf en/reference/dev
	# remove Makefile
	rm Makefile
	# Put singular help file where it is expected
	cp "${WORKDIR}"/Singular/3-1-6/info/singular.hlp ./

	# install missing directories to satisfy builder.py test
	mkdir -p output/doctrees/en/tutorial
	mkdir -p en/tutorial/templates
	mkdir -p en/tutorial/static
	mkdir -p en/reference/templates
	mkdir -p en/reference/static

	if use html ; then
		mkdir -p output/html
		cp -r "${WORKDIR}"/${MY_P_HTML}/* output/html/
	fi

	if use pdf ; then
		mkdir -p output/pdf
		cp -r "${WORKDIR}"/${MY_P_PDF}/* output/pdf/
	fi
}

src_install() {
	docompress -x /usr/share/doc/sage
	# TODO: check if all of these files are needed
	# not installing doc build system
	rm common/builder.py
	rm common/custom-sphinx-build.py
	insinto /usr/share/doc/sage
	doins -r *
}

pkg_postinst() {
	if ! use html ; then
		ewarn "You haven't requested the html documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
	fi
}
