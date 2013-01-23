# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils prefix versionator

MY_P="sage_scripts-$(replace_version_separator 2 '.')"
SAGEROOT="sage_root-$(replace_version_separator 2 '.')"

DESCRIPTION="Sage baselayout files"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sagemath/${MY_P}.spkg -> ${P}.tar.bz2
	mirror://sagemath/${SAGEROOT}.spkg -> ${SAGEROOT}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="debug testsuite X tools"

RESTRICT="mirror"

DEPEND=""
if  [[ ${CHOST} == *-darwin* ]] ; then
	RDEPEND="${DEPEND}
		tools? ( dev-vcs/mercurial )
		debug? ( sys-devel/gdb-apple )"
else
	RDEPEND="${DEPEND}
		tools? ( dev-vcs/mercurial )
		debug? ( sys-devel/gdb )"
fi

S="${WORKDIR}/${MY_P}"
ROOT_S="${WORKDIR}/${SAGEROOT}"

# TODO: scripts into /usr/libexec ?
src_prepare() {
	# ship our own version of sage-env
	cat > sage-env <<-EOF
		#!/bin/bash

		export SAGE_ROOT="${EPREFIX}/usr/share/sage"
		export SAGE_LOCAL="${EPREFIX}/usr/"
		export SAGE_DATA="${EPREFIX}/usr/share/sage"
		export SAGE_SHARE="${EPREFIX}/usr/share/sage"
		export SAGE_DOC="${EPREFIX}/usr/share/sage/devel/sage/doc"
		export SAGE_EXTCODE="${EPREFIX}/usr/share/sage/ext"

		if [[ -z \${DOT_SAGE} ]]; then
			export DOT_SAGE="\${HOME}/.sage"
		fi

		export SAGE_STARTUP_FILE="\${DOT_SAGE}/init.sage"
		export SAGE_TESTDIR="\${DOT_SAGE}/tmp"
		export SAGE_SERVER="http://www.sagemath.org/"
		export EPYTHON=python2.7
		export MPMATH_NOGMPY=1
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

	# replace ${SAGE_ROOT}/local with ${SAGE_LOCAL}
	epatch "${FILESDIR}"/${PN}-4.7.2-fix-SAGE_LOCAL.patch

	# solve sage-notebook start-up problems (after patching them)
	mv sage-notebook sage-notebook-real
	mv sage-notebook-insecure sage-notebook-insecure-real

	cat > sage-notebook <<-EOF
		#!/bin/bash

		source ${EPREFIX}/etc/sage-env
		${EPREFIX}/usr/bin/sage-notebook-real "\$@"
	EOF

	cat > sage-notebook-insecure <<-EOF
		#!/bin/bash

		source ${EPREFIX}/etc/sage-env
		${EPREFIX}/usr/bin/sage-notebook-insecure-real "\$@"
	EOF

	# sage startup script is placed into /usr/bin
	sed -i "s:\"\$SAGE_ROOT\"/sage:\"\$SAGE_LOCAL\"/bin/sage:g" \
		sage-maketest || die "failed to patch path for Sage's startup script"

	# TODO: if USE=debug/testsuite, remove corresponding options

	# replace $SAGE_ROOT/local with $SAGE_LOCAL
	sed -i "s:\$SAGE_ROOT/local:\$SAGE_LOCAL:g" sage-gdb sage-gdb-ipython \
		sage-cachegrind sage-callgrind sage-massif sage-omega sage-valgrind \
		|| die "failed to patch GNU Debugger scripts"

	# replace MAKE by MAKEOPTS in sage-num-threads.py
	sed -i "s:os.environ\[\"MAKE\"\]:os.environ\[\"MAKEOPTS\"\]:g" \
		sage-num-threads.py

	# remove developer- and unsupported options
	cd "${ROOT_S}"
	epatch "${FILESDIR}"/${PN}-5.4-gentooify-startup-script-2.patch.bz2
	eprefixify spkg/bin/sage
}

src_install() {
	# TODO: patch sage-core and remove sage-native-execute ?

	# core scripts which are needed in every case
	dobin sage-cleaner sage-banner sage-eval sage-ipython \
		sage-maxima.lisp sage-native-execute sage-run sage-num-threads.py \
		sage-rst2txt sage-rst2sws

	dobin "${ROOT_S}"/spkg/bin/sage

	# install sage-env under /etc
	insinto /etc
	doins sage-env

	if use testsuite ; then
		# DOCTESTING helper scripts
		dobin sage-doctest sage-maketest sage-ptest sage-test
	fi

	if use tools ; then
		# install some of sage tools for spkg development
		dobin sage-pkg
	fi

	# COMMAND helper scripts
	dobin sage-cython sage-notebook* sage-python sage-run-cython

	# additonal helper scripts
	dobin sage-preparse sage-startuptime.py

	if use debug ; then
		# GNU DEBUGGER helper schripts
		dobin sage-gdb sage-gdb-ipython sage-gdb-commands

		# VALGRIND helper scripts
		dobin sage-cachegrind sage-callgrind sage-massif sage-omega \
			sage-valgrind
	fi

	insinto /usr/bin
	doins *doctest.py ipy_profile_sage.py

	insinto /usr/share/sage
	doins -r "${ROOT_S}"/ipython
	doins "${ROOT_S}"/COPYING.txt

	insinto /etc
	doins "${FILESDIR}"/gprc.expect

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
