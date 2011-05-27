# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils toolchain-funcs versionator

SAGE_P="sage-$(replace_version_separator 2 '.')"
MY_P="sage_scripts-$(replace_version_separator 2 '.')"
SAGEROOT="sage_root-$(replace_version_separator 2 '.')"

DESCRIPTION="Sage baselayout files"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2
	http://sage.math.washington.edu/home/release/${SAGE_P}/${SAGE_P}/spkg/standard/${SAGEROOT}.spkg -> ${SAGEROOT}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug testsuite X"

RESTRICT="mirror"

DEPEND=""
if  [[ ${CHOST} == *-darwin* ]] ; then
	RDEPEND="${DEPEND}
		debug? ( sys-devel/gdb-apple )"
else
	RDEPEND="${DEPEND}
		debug? ( sys-devel/gdb )"
fi

S="${WORKDIR}/${MY_P}"
IPYTHON_S="${WORKDIR}/${SAGEROOT}"

# TODO: scripts into /usr/libexec ?
src_prepare() {
	# ship our own version of sage-env
	rm sage-env || die "failed to remove sage-env"

	cat > sage-env <<-EOF
		#!/bin/bash

		if [[ -z \${DOT_SAGE} ]]; then
			export DOT_SAGE="\${HOME}/.sage"
		fi

		export SAGE_STARTUP_FILE="\${DOT_SAGE}/init.sage"
		export SAGE_TESTDIR="\${DOT_SAGE}/tmp"
		export SAGE_SERVER="http://www.sagemath.org/"
		export EPYTHON=python2.7
	EOF

	# make sage startup script
	cat > sage <<-EOF
		#!/bin/bash

		export CUR=\$(pwd)
		. ${EPREFIX}/usr/bin/sage-env
		${EPREFIX}/usr/bin/sage-sage "\$@"
	EOF

	# These variables must be globally available (e.g. for sympy-0.6.7)
	cat > "${T}"/99sage <<-EOF
		SAGE_ROOT="${EPREFIX}/usr/share/sage"
		SAGE_LOCAL="${EPREFIX}/usr"
		SAGE_DATA="${EPREFIX}/usr/share/sage/data"
		SAGE_DOC="${EPREFIX}/usr/share/sage/devel/sage/doc"
	EOF

	# make .desktop file
	cat > "${T}"/sage-sage.desktop <<-EOF
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

	# TODO: do not remove scons and M2

	# remove developer- and unsupported options
	epatch "${FILESDIR}"/${PN}-4.6.1_rc0-gentooify-startup-script.patch

	# we dont need this script
	epatch "${FILESDIR}"/${PN}-4.5.1-remove-sage-location.patch

	# replace ${SAGE_ROOT}/local with ${SAGE_LOCAL}
	epatch "${FILESDIR}"/${PN}-4.5.2-fix-SAGE_LOCAL.patch

	# solve sage-notebook start-up problems (after patching them)
	mv sage-notebook sage-notebook-real
	mv sage-notebook-insecure sage-notebook-insecure-real

	cat > sage-notebook <<-EOF
		#!/bin/bash

		source ${EPREFIX}/usr/bin/sage-env
		${EPREFIX}/usr/bin/sage-notebook-real "\$@"
	EOF

	cat > sage-notebook-insecure <<-EOF
		#!/bin/bash

		source ${EPREFIX}/usr/bin/sage-env
		${EPREFIX}/usr/bin/sage-notebook-insecure-real "\$@"
	EOF

	# sage startup script is placed into /usr/bin
	sed -i "s:\"\$SAGE_ROOT\"/sage:\"\$SAGE_LOCAL\"/bin/sage:g" \
		sage-maketest || die "failed to patch path for Sage's startup script"

	sed -i "s:sage_fortran:$(tc-getFC):g" sage-g77_shared \
		|| die "failed to patch fortran compiler path"

	# TODO: if USE=debug/testsuite, remove corresponding options

	# replace $SAGE_ROOT/local with $SAGE_LOCAL
	sed -i "s:\$SAGE_ROOT/local:\$SAGE_LOCAL:g" sage-gdb sage-gdb-ipython \
		sage-cachegrind sage-callgrind sage-massif sage-omega sage-valgrind \
		|| die "failed to patch GNU Debugger scripts"
}

src_install() {
	# TODO: patch sage-core and remove sage-native-execute ?

	# core scripts which are needed in every case
	dobin sage sage-banner sage-cleaner sage-env sage-eval sage-ipython \
		sage-maxima.lisp sage-native-execute sage-run sage-sage

	if use testsuite ; then
		# DOCTESTING helper scripts
		dobin sage-doctest sage-maketest sage-ptest sage-starts sage-test
	fi

	# COMMAND helper scripts
	dobin sage-cython sage-notebook* sage-python

	# additonal helper scripts
	dobin sage-grep sage-grepdoc sage-preparse sage-startuptime.py

	if use debug ; then
		# GNU DEBUGGER helper schripts
		dobin sage-gdb sage-gdb-ipython sage-gdb-commands

		# VALGRIND helper scripts
		dobin sage-cachegrind sage-callgrind sage-massif sage-omega \
			sage-valgrind
	fi

	# install file for sage/misc/inline_fortran.py
	dobin sage-g77_shared

	insinto /usr/bin
	doins *doctest.py ipy_profile_sage.py

	insinto /usr/share/sage
	doins -r "${IPYTHON_S}"/ipython

	doenvd "${T}"/99sage

	# install devel directories and link
	dodir /usr/share/sage/devel/sage-main
	dosym /usr/share/sage/devel/sage-main /usr/share/sage/devel/sage

	if use X ; then
		# unpack icon
		cp "${FILESDIR}"/sage.svg.bz2 "${T}" || die "failed to copy icon"
		bzip2 -d "${T}"/sage.svg.bz2 || die "failed to unzip icon"

		doicon "${T}"/sage.svg
		domenu "${T}"/sage-sage.desktop
	fi
}

pkg_postinst() {
	einfo "${PN} has installed a file into /etc/env.d - if you"
	einfo "have installed it for the very first time update your environment"
	einfo "with:"
	einfo ""
	einfo "  env-update && source /etc/profile"
	einfo ""
	einfo "or logoff and logon to your shell, otherwise Sage will fail to start"
}
