# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit sage

DESCRIPTION="Documentation for Sage"
HOMEPAGE="http://www.sagemath.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_en linguas_fr"

# TODO: build html, pdf
# TODO: Handle LINGUAS=en,fr

# in fact sage ships twisted-8.2.0
DEPEND=">=dev-python/sphinx-0.6.3
	>=dev-python/twisted-8.1.0
	=sci-mathematics/sage-4.2.1"
RDEPEND="${DEPEND}"

src_compile() {
	export SAGE_DOC_DEST="${D}"

	# TODO: fix sandbox violation errors
	/opt/sage/sage -docbuild all html
}

src_install() {
	# TODO: install docs
	exit 1
}
