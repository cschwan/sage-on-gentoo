# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils sage

MY_P="sage_scripts-${PV}"

DESCRIPTION="Sage's scripts"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

# TODO: Problem with Singular: devel/sage/sage/modules/free_module.py
# TODO: once we are sure which files are needed install them instead of removing
# files which not needed

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.4.3-gentooify-scripts.patch

	# remove files not needed
	rm sage-README-osx.txt || die "rm failed"

	# Sage's development files
	rm sage-apply-ticket sage-clone sage-coverage sage-coverageall sage-crap \
		sage-fixdoctests sage-grep sage-grepdoc || die "rm failed"

	# delete Sage's marcurial helpers
	rm sage-pull sage-push || die "rm failed"

	# this file does nothing
	rm sage-verify-pyc || die "rm failed"

	# removing sage-spkg breaks sage-notebook

	# delete files for Sage's build system
	rm sage-bdist sage-build sage-build-debian sage-check-64 \
		sage-hardcode_sage_root sage-make_devel_packages sage-sdist \
		sage-spkg-install sage-sync-build.py || die "rm failed"

	# files for windows are not needed
	rm sage-rebase_sage.sh || die "rm failed"

	# files for MacOSX are not needed
	rm sage-check-libraries.py sage-ldwrap sage-open sage-osx-open \
		|| die "rm failed"

	# an upgrade is done with portage
	rm sage-download_package sage-latest-online-package sage-list-experimental \
		sage-list-optional sage-list-packages sage-list-standard sage-update \
		sage-update-build sage-upgrade || die "rm failed"

	# we dont need debian stuff
	rm sage-debsource sage-sbuildhack || die "rm failed"

	# python script which opens changelog.txt with emacs
	rm sage-log || die "rm failed"

	# remove fortran compile script
	rm sage-g77_shared || die "rm failed"

	# some of William Stein's personal scripts ?
	rm sage-mirror sage-mirror-darcs-scripts || die "rm failed"
}

# TODO: Scripts into libexec, ipython into /usr/share ?

src_install() {
	dodoc README.txt || die "dodoc failed"

	into "${SAGE_LOCAL}"
	dobin sage-* || die "dobin failed"

	insinto "${SAGE_LOCAL}"/bin
	doins *doctest.py ipy_profile_sage.py || die "doins failed"

	exeinto "${SAGE_ROOT}"
	doexe sage-python || die "doexe failed"

	insinto "${SAGE_ROOT}"
	doins -r ipython || die "doins failed"

	# TODO: fix paths
	dosym $(which python) "${SAGE_LOCAL}"/bin/sage.bin
	dosym $(which gp) "${SAGE_LOCAL}"/bin/sage_pari
}
