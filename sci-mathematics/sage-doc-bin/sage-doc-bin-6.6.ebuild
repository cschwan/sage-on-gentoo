# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit base

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

MY_P_HTML="sage-${PV}-doc-html"
#MY_P_PDF="sage-${PV}-doc-pdf"

DESCRIPTION="Documentation, tutorials and help files for Sage (pre-built html/pdf)"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="mirror://sagemath/${PV}.tar.gz -> sage-${PV}.tar.gz
	http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/3-1-6/Singular-3-1-6-share.tar.gz
	html? ( mirror://sagemathdoc/${MY_P_HTML}.tar.xz )"
#	pdf? ( mirror://sagemathdoc/${MY_P_PDF}.tar.bz2 )"

LANGS="ca de en fr hu it pt ru tr"

LICENSE="GPL-2"
SLOT="0"
#IUSE="+html pdf"
IUSE="+html"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

RESTRICT="mirror"

DEPEND="!sci-mathematics/sage-doc"
RDEPEND="${DEPEND}
	>=dev-python/sphinx-1.2.2"

S="${WORKDIR}/sage-${PV}/src/doc"

REQUIRED_USE="html? ( linguas_en )"

PATCHES=( "${FILESDIR}"/${PN}-6.0-misc.patch
	"${FILESDIR}"/${PN}-6.6-linguas.patch )

src_prepare() {
	base_src_prepare

	# remove documentation about non-existent dev tools
	rm -rf en/reference/dev
	# remove Makefile
	rm Makefile
	# Put singular help file where it is expected
	cp "${WORKDIR}"/Singular/3-1-6/info/singular.hlp ./

	if use html ; then
		mkdir -p output/html
		for lang in ${LANGS} ; do
			use linguas_$lang && cp -r "${WORKDIR}"/${MY_P_HTML}/${lang} output/html/
		done
	fi

	#if use pdf ; then
	#	mkdir -p output/pdf
	#	for lang in ${LANGS} ; do
	#		use linguas_$lang && cp -r "${WORKDIR}"/${MY_P_PDF}/${lang} output/pdf/
	#	done
	#fi
}

src_install() {
	docompress -x /usr/share/doc/sage

	insinto /usr/share/doc/sage
	doins singular.hlp
	for lang in ${LANGS} ; do
		use linguas_$lang && doins -r $lang
	done

	insinto /usr/share/doc/sage/common
	# not installing doc build system
	rm common/builder.py
	rm common/custom-sphinx-build.py
	doins -r common/*

	if use html ; then
		insinto /usr/share/doc/sage/output/html
		doins -r output/html/*
	fi

	#if use pdf ; then
	#	insinto /usr/share/doc/sage/output/pdf
	#	doins -r output/pdf/*
	#fi
}

pkg_postinst() {
	if ! use html ; then
		ewarn "You haven't requested the html documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
	fi
}
