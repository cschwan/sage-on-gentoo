# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit sage

MY_P="sage-${PV}"
MY_P_HTML="sage-${PV}-doc-html"
MY_P_PDF="sage-${PV}-doc-pdf"

DESCRIPTION="Documentation for Sage"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> sage-core-${PV}.tar.bz2
	doc? ( http://www.sagemath.org/doc-bz2/${MY_P_HTML}.tar.bz2
	pdf? ( http://www.sagemath.org/doc-bz2/${MY_P_PDF}.tar.bz2 ) )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc pdf"

RESTRICT="mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}/doc"

src_install() {
	# TODO: check if all these files are needed
	rm -rf output || die "rm failed"
	insinto "${SAGE_ROOT}"/devel/sage-main/doc
	doins -r * || die "doins failed"

	if use doc ; then
		cd "${WORKDIR}"/${MY_P_HTML}
		insinto "${SAGE_ROOT}"/devel/sage-main/doc/output/html
		doins -r * || die "doins failed"

		if use pdf ; then
			cd "${WORKDIR}"/${MY_P_PDF}
			insinto "${SAGE_ROOT}"/devel/sage-main/doc/output/pdf
			doins -r * || die "doins failed"
		fi
	fi
}

pkg_postinst() {
	if ! use doc ; then
		ewarn "You haven't requested the documentation."
		ewarn "If you don't install sage-doc the html documentation won't be"
		ewarn "available in sage notebook."
	fi
}
