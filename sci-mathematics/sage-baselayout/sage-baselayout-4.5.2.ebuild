# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils toolchain-funcs

MY_P="sage_scripts-${PV}"

DESCRIPTION="Sage baselayout files"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug testsuite X"

RESTRICT="mirror"

DEPEND="!!<sci-mathematics/sage-4.5.2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

# TODO: scripts into /usr/libexec ?
src_prepare() {
	# make sage startup script
	cat > "${S}"/sage <<-EOF
		#!/bin/bash

		export CUR=\$(pwd)
		. ${EPREFIX}/usr/bin/sage-env
		${EPREFIX}/usr/bin/sage-sage "\$@"
	EOF

	# ship our own version of sage-env
	rm sage-env || die "failed to remove sage-env"
	cat > "${S}"/sage-env <<-EOF
		#!/bin/bash

		export SAGE_ROOT="${EPREFIX}/usr/share/sage"
		export SAGE_LOCAL="${EPREFIX}/usr"
		export SAGE_DATA="\${SAGE_ROOT}/data"
		export SAGE_DOC="\${SAGE_ROOT}/devel/sage/doc"

		export SAGE_SERVER="http://www.sagemath.org/"
		export DOT_SAGE="\${HOME}/.sage/"
		export SAGE_STARTUP_FILE="\${DOT_SAGE}/init.sage"
		export SAGE_TESTDIR="\${DOT_SAGE}/tmp"
	EOF

	epatch "${FILESDIR}"/${PN}-4.5.1-remove-useless-options.patch
	epatch "${FILESDIR}"/${PN}-4.5.1-remove-sage-location.patch
	epatch "${FILESDIR}"/${PN}-4.5.2-fix-SAGE_LOCAL.patch

	sed -i "s:\"\$SAGE_ROOT\"/sage:\"\$SAGE_LOCAL\"/bin/sage:g" \
		sage-maketest || die "failed to patch SAGE_LOCAL path"

	sed -i "s:sage_fortran:$(tc-getFC):g" sage-g77_shared \
		|| die "failed to patch fortran compiler path"

	# TODO: if USE=debug/testsuite, remove corresponding options

	rm ipython/*pyc || die "failed to remove compiled python files"
}

src_install() {
	dodoc README.txt || die

	# TODO: patch sage-core and remove sage-native-execute ?

	# core scripts which are needed in every case
	dobin sage sage-banner sage-cleaner sage-env sage-eval sage-ipython \
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

	# install file for sage/misc/inline_fortran.py
	dobin sage-g77_shared || die

	insinto /usr/bin
	doins *doctest.py ipy_profile_sage.py || die

	insinto /usr/share/sage
	doins -r ipython || die

	# install devel directories and link
	dodir /usr/share/sage/devel/sage-main || die
	dosym /usr/share/sage/devel/sage-main /usr/share/sage/devel/sage || die

	if use X ; then
		# unpack icon
		cp "${FILESDIR}"/sage.svg.bz2 . || die "failed to copy icon"
		bzip2 -d sage.svg.bz2 || die "failed to unzip icon"

		# install icon
		doicon sage.svg || die

		# make .desktop file
		cat > sage-sage.desktop <<-EOF
			[Desktop Entry]
			Name=Sage Shell
			Type=Application
			Comment=Math software for algebra, geometry, number theory, cryptography and numerical computation
			Exec=sage
			TryExec=sage
			Icon=sage
			Categories=Education;Science;Math;
			Terminal=true
		EOF

		# install .desktop file
		domenu sage-sage.desktop || die
	fi
}
