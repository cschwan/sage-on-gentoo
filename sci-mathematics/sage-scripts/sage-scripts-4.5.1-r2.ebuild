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
IUSE="debug wiki"

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.5.1-remove-useless-options.patch
	epatch "${FILESDIR}"/${PN}-4.5.1-remove-useless-variables.patch
	epatch "${FILESDIR}"/${PN}-4.5-remove-sage-location.patch

	# TODO: remove SINGULAR* variable once we have a clean singular ebuild
	epatch "${FILESDIR}"/${PN}-4.5.1-fix-singular-path.patch

	eprefixify "${S}"/sage-env

	rm ipython/*pyc || die "failed to remove compiled python files"
}

# TODO: Scripts into libexec, ipython into /usr/share ?

src_install() {
	dodoc README.txt || die

	into "${SAGE_LOCAL}"

	# core scripts which are needed in every case
	dobin sage-banner sage-cleaner sage-env sage-eval sage-ipython \
		sage-maxima.lisp sage-native-execute sage-run sage-sage \
		sage-startuptime.py || die

	# DOCTESTING helper scripts
	dobin sage-doctest sage-maketest sage-ptest sage-starts sage-test || die

	# COMMAND helper scripts
	dobin sage-cython sage-notebook sage-notebook-insecure sage-startuptime.py \
		|| die

	if use debug ; then
		# GNU DEBUGGER helper schripts
		dobin sage-gdb sage-gdb-ipython sage-gdb-commands || die

		# VALGRIND helper scripts
		dobin sage-cachegrind sage-callgrind sage-massif sage-omega \
			sage-valgrind || die
	fi

	if use wiki ; then
		dobin sage-wiki || die
	fi

	insinto "${SAGE_LOCAL}"/bin
	doins *doctest.py ipy_profile_sage.py || die

	exeinto "${SAGE_ROOT}"
	doexe sage-python || die

	insinto "${SAGE_ROOT}"
	doins -r ipython || die
}
