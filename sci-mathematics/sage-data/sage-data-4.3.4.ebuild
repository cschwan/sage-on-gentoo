# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit sage

MY_P=( conway_polynomials-0.2 elliptic_curves-0.1 graphs-20070722.p1
polytopes_db-20100210 )

DESCRIPTION="Data for Sage"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P[0]}.spkg -> ${MY_P[0]}.tar.bz2
	mirror://sage/spkg/standard/${MY_P[1]}.spkg -> ${MY_P[1]}.tar.bz2
	mirror://sage/spkg/standard/${MY_P[2]}.spkg -> ${MY_P[2]}.tar.bz2
	mirror://sage/spkg/standard/${MY_P[3]}.spkg -> ${MY_P[3]}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto "${SAGE_DATA}"

	# install conway_polynomials
	doins -r ${MY_P[0]}/src/conway_polynomials/ || die "doins failed"

	# install elliptic_curves
	rm ${MY_P[1]}/ellcurves/spkg-install || die "rm failed"

	doins -r ${MY_P[1]}/cremona_mini/src/cremona_mini || die "doins failed"
	doins -r ${MY_P[1]}/ellcurves || die "doins failed"

	# install graphs
	doins -r ${MY_P[2]}/graphs || die "doins failed"

	# install polytopes_db
	doins -r ${MY_P[3]}/reflexive_polytopes || die "doins failed"
}
