# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit multilib sage

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
	sed -i "s:SAGE_ROOT=\"\.\.\.\.\.\":SAGE_ROOT=\"${EPREFIX}${SAGE_ROOT}\":g" sage \
		|| die "sed failed"
}

src_install() {
	exeinto "${SAGE_ROOT}"
	doexe sage || die "doexe failed"

	# install a symbolic link so that sage is actually found
	dosym "${SAGE_ROOT}"/sage "${SAGE_PREFIX}"/bin/sage || die "dosym failed"

	# correctly create library dir
	dodir "${SAGE_LOCAL}/$(get_libdir)" || die "dodir failed"

	# Sage needs also a lib dir
	if [[ $(get_libdir) != lib ]]; then
		dosym "${SAGE_LOCAL}/$(get_libdir)" "${SAGE_LOCAL}"/lib \
			|| die "dodir failed"
	fi

	# install devel directories and link
	dodir "${SAGE_ROOT}"/devel/sage-main || die "dodir failed"
	dosym "${SAGE_ROOT}"/devel/sage-main "${SAGE_ROOT}"/devel/sage \
		|| die "dosym failed"
}
