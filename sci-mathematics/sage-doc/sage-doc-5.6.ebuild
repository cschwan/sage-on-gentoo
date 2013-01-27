# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils versionator

MY_PV="${PV}"
#MY_PV="5.5"
MY_P="sage-$(replace_version_separator 2 '.')"
MY_P_HTML="sage-${MY_PV}-doc-html"
MY_P_PDF="sage-${MY_PV}-doc-pdf"

DESCRIPTION="Documentation, tutorials and help files for Sage"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="mirror://sagemath/${MY_P}.spkg -> sage-${PV}.tar.bz2
	http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/3-1-5/Singular-3-1-5-share.tar.gz
	html? ( http://www.sagemath.org/doc-bz2/${MY_P_HTML}.tar.bz2 -> sage-doc-html-${MY_PV}.tar.bz2 )
	pdf? ( http://www.sagemath.org/doc-bz2/${MY_P_PDF}.tar.bz2 -> sage-doc-pdf-${MY_PV}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="html pdf"

RESTRICT="mirror"

# TODO: depend on sage-baselayout (creates sage-main directory) ?
DEPEND=""
RDEPEND=">=dev-python/sphinx-1.1.2"

S="${WORKDIR}"/${MY_P}/doc

src_install() {
	# install missing directories to satisfy builder.py test
	dodir /usr/share/sage/devel/sage-main/doc/output/doctrees/en/tutorial
	dodir /usr/share/sage/devel/sage-main/doc/en/tutorial/templates
	dodir /usr/share/sage/devel/sage-main/doc/en/tutorial/static
	dodir /usr/share/sage/devel/sage-main/doc/en/reference/templates
	dodir /usr/share/sage/devel/sage-main/doc/en/reference/static

	# TODO: check if all of these files are needed
	rm -rf output || die "failed to remove useless files"
	insinto /usr/share/sage/devel/sage-main/doc
	doins -r *
	doins "${WORKDIR}"/Singular/3-1-5/info/singular.hlp

	if use html ; then
		cd "${WORKDIR}"/${MY_P_HTML}
		insinto /usr/share/sage/devel/sage-main/doc/output/html
		doins -r *
	fi

	if use pdf ; then
		cd "${WORKDIR}"/${MY_P_PDF}
		insinto /usr/share/sage/devel/sage-main/doc/output/pdf
		doins -r *
	fi
}

pkg_postinst() {
	if ! use html ; then
		ewarn "You haven't requested the html documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
	fi
}
