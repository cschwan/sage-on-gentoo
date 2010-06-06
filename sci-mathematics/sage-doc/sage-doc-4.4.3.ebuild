# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils sage

MY_P="sage-${PV}"
MY_P_HTML="sage-${PV}-doc-html"
MY_P_PDF="sage-${PV}-doc-pdf"

DESCRIPTION="Documentation for Sage"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> sage-core-${PV}.tar.bz2
	html? ( http://www.sagemath.org/doc-bz2/${MY_P_HTML}.tar.bz2 )
	pdf? ( http://www.sagemath.org/doc-bz2/${MY_P_PDF}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="html pdf"

RESTRICT="mirror"

DEPEND=""
RDEPEND=">=dev-python/sphinx-0.6.3"

S="${WORKDIR}/${MY_P}/doc"

src_prepare() {
	# Patch the tests in the documentation to use cvxopt-1.1.2
	epatch "${FILESDIR}"/${PN}-cvxopt-1.1.2.patch
}

src_install() {
	# TODO: check if all of these files are needed
	rm -rf output || die "rm failed"
	insinto "${SAGE_ROOT}"/devel/sage-main/doc
	doins -r * || die "doins failed"

	if use html ; then
		cd "${WORKDIR}"/${MY_P_HTML}
		insinto "${SAGE_ROOT}"/devel/sage-main/doc/output/html
		doins -r * || die "doins failed"
	fi

	if use pdf ; then
		cd "${WORKDIR}"/${MY_P_PDF}
		insinto "${SAGE_ROOT}"/devel/sage-main/doc/output/pdf
		doins -r * || die "doins failed"
	fi
}

pkg_postinst() {
	if ! use html ; then
		ewarn "You haven't requested the html documentation."
		ewarn "The html version of the sage manual won't be available in the sage notebook."
	fi
}
