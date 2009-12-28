# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SAGE_VERSION="${PV}"
SAGE_PACKAGE[0]=conway_polynomials-0.2
SAGE_PACKAGE[1]=elliptic_curves-0.1
SAGE_PACKAGE[2]=graphs-20070722.p1
SAGE_PACKAGE[3]=polytopes_db-20080430

inherit sage

DESCRIPTION="Data for Sage"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto "${SAGE_DATA}"

	# install conway_polynomials
	doins -r ${SAGE_PACKAGE[0]}/src/conway_polynomials/ || die "doins failed"

	# install elliptic_curves
	rm ${SAGE_PACKAGE[1]}/ellcurves/spkg-install || die "rm failed"

	doins -r ${SAGE_PACKAGE[1]}/cremona_mini/src/cremona_mini \
		|| die "doins failed"
	doins -r ${SAGE_PACKAGE[1]}/ellcurves || die "doins failed"

	# install graphs
	doins -r ${SAGE_PACKAGE[2]}/graphs || die "doins failed"

	# install polytopes_db
	doins -r polytopes_db-20080430/reflexive_polytopes || die "doins failed"
}
