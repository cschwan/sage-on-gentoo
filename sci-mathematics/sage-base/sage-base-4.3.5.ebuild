# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit sage

DESCRIPTION="Sage baselayout"
HOMEPAGE="http://www.sagemath.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_compile() {
	cp "${FILESDIR}"/sage . || die "cp failed"

	# correctly set SAGE_ROOT
	sed -i "s:SAGE_ROOT=\"\.\.\.\.\.\":SAGE_ROOT=\"${SAGE_ROOT}\":g" sage \
		|| die "sed failed"
}

src_install() {
	into "${SAGE_ROOT}"
	doexe sage || die "doexe failed"

	# install a symbolic link so that sage is actually found
	dosym "${SAGE_PREFIX}"/bin/sage "${SAGE_ROOT}"/sage || die "dosym failed"

	# this directory is needed by sage-core
	dodir "${SAGE_ROOT}"/spkg/installed || die "dodir failed"
}
