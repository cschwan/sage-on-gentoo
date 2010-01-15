# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION=${PV}
SAGE_PACKAGE=dsage-1.0.1.p0

NEED_PYTHON=2.6

inherit distutils sage

# TODO: description
DESCRIPTION="Distributed Sage allows you to do distributed computing in Sage"
# HOMEPAGE=""
# SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

# TODO: dependencies from makefile: python and sage

# TODO: find out dependencies
DEPEND=""
RDEPEND="${DEPEND}"

# TODO: write a src_test function
# TODO: fix paths

src_prepare() {
	cat >> setup.cfg <<-EOF
		[install]
		prefix = ${SAGE_LOCAL}
	EOF

	distutils_src_prepare
}
