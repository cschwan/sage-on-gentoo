# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils prefix sage

MY_P="sage_scripts-${PV}"

DESCRIPTION="Sage's scripts"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug testsuite"

RESTRICT="mirror"

# TODO: remove once sage-base is gone
DEPEND="!!sci-mathematics/sage-base"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# make sage starting script
	cat > "${S}"/sage <<-EOF
		#!/bin/bash

		export CUR=\$(pwd)
		. ${SAGE_LOCAL}/bin/sage-env
		${SAGE_LOCAL}/bin/sage-sage "\$@"
	EOF

	epatch "${FILESDIR}"/${PN}-4.5.1-remove-useless-options.patch
	epatch "${FILESDIR}"/${PN}-4.5.1-remove-useless-variables-v2.patch
	epatch "${FILESDIR}"/${PN}-4.5-remove-sage-location.patch
	eprefixify "${S}"/sage-env

	if use testsuite ; then
		epatch "${FILESDIR}"/${PN}-4.5.1-fix-doctest.patch
	fi

	# TODO: remove wiki options
	# TODO: if USE=debug/testsuite, remove corresponding options

	rm ipython/*pyc || die "failed to remove compiled python files"
}

# TODO: Scripts into libexec, ipython into /usr/share ?

src_install() {
	dodoc README.txt || die

	into "${SAGE_LOCAL}"

	# TODO: patch sage-core and remove sage-native-execute ?

	# core scripts which are needed in every case
	dobin sage-banner sage-cleaner sage-env sage-eval sage-ipython \
		sage-maxima.lisp sage-native-execute sage-run sage-sage \
		sage-startuptime.py || die

	if use testsuite ; then
		# DOCTESTING helper scripts
		dobin sage-doctest sage-maketest sage-ptest sage-starts sage-test || die
	fi

	# COMMAND helper scripts
	dobin sage-cython sage-notebook sage-notebook-insecure sage-python \
		sage-startuptime.py || die

	if use debug ; then
		# GNU DEBUGGER helper schripts
		dobin sage-gdb sage-gdb-ipython sage-gdb-commands || die

		# VALGRIND helper scripts
		dobin sage-cachegrind sage-callgrind sage-massif sage-omega \
			sage-valgrind || die
	fi

	insinto "${SAGE_LOCAL}"/bin
	doins *doctest.py ipy_profile_sage.py || die

	insinto "${SAGE_ROOT}"
	doins -r ipython || die

	exeinto "${SAGE_PREFIX}"/bin
	doexe sage || die

	# install devel directories and link
	dodir "${SAGE_ROOT}"/devel/sage-main || die "dodir failed"
	dosym "${SAGE_ROOT}"/devel/sage-main "${SAGE_ROOT}"/devel/sage \
		|| die "dosym failed"
}
