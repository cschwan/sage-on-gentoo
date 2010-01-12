# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SAGE_VERSION=${PV}
SAGE_PACKAGE=sage_scripts-${PV}

NEED_PYTHON=2.6

inherit multilib python sage

# TODO: write description
DESCRIPTION=""
# HOMEPAGE=""
# SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	# remove files not needed
	rm sage-banner.orig
	rm sage-README-osx.txt

	# TODO: gphelp is installed only if pari was emerged with USE=doc and
	# documentation additionally needs FEATURES=nodoc _not_ set.
	# TODO: fix directories containing version strings

	# fix pari, ecl, R and python paths
	sed -i \
		-e "s:\$SAGE_LOCAL/share/pari:/usr/share/pari:g" \
		-e "s:\$SAGE_LOCAL/bin/gphelp:/usr/bin/gphelp:g" \
		-e "s:\$SAGE_LOCAL/share/pari/doc:/usr/share/doc/pari-2.3.4-r1:g" \
		-e "s:\$SAGE_ROOT/local/lib/R/lib:/usr/lib/R/lib:g" \
		-e "s:\$SAGE_LOCAL/lib/R:/usr/lib/R:g" \
		-e "s:ECLDIR=:#ECLDIR=:g" \
		-e "s:\"\$SAGE_ROOT/local/lib/python\":\"\$SAGE_ROOT/local/$(get_libdir)/python\":g" \
		-e "s:PYTHONPATH=\"\(.*\)\":PYTHONPATH=\"$(python_get_sitedir)\:\1\:\$SAGE_ROOT/local/$(get_libdir)/python/site-packages\":g" \
		-e "/PYTHONHOME=.*/d" \
		sage-env
}

src_install() {
	into "${SAGE_LOCAL}"
	dobin sage-* || die "dobin failed"
	dobin dsage_* || die "dobin failed"

	insinto "${SAGE_LOCAL}"/bin
	doins *doctest.py ipy_profile_sage.py || die "doins failed"

	exeinto "${SAGE_ROOT}"
	doexe sage-python || die "doexe failed"

	insinto "${SAGE_ROOT}"
	doins -r ipython || die "doins failed"

	# TODO: fix paths
	dosym $(which python) "${SAGE_LOCAL}"/bin/sage.bin
	dosym Singular "${SAGE_LOCAL}"/bin/sage_singular
	dosym $(which gp) "${SAGE_LOCAL}"/bin/sage_pari
}
