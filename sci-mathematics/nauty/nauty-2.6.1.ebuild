# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator

MY_PV=$(replace_version_separator 2 'r')
MY_PV=$(delete_version_separator 1 ${MY_PV})

DESCRIPTION="Computing automorphism groups of graphs and digraphs"
HOMEPAGE="http://pallini.di.uniroma1.it/"
SRC_URI="http://pallini.di.uniroma1.it/${PN}${MY_PV}.tar.gz"

LICENSE="nauty"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}${MY_PV}"

src_prepare () {
	sed \
		-e "s/^LDFLAGS=.*/LDFLAGS=${LDFLAGS}/" \
		-e 's:${CC} -o:${CC} ${LDFLAGS} -o:g' \
		-e 's:${LDFLAGS}$::g' \
		-i makefile.in || die
}

src_test () {
	emake checks
	./runalltests
}

src_install () {
	# get the list of executables for the nauty target
	dobin copyg listg labelg dretog amtog geng complg showg NRswitchg \
		biplabg addedgeg deledgeg countg pickg genrang newedgeg catg genbg \
		directg gentreeg genquarticg \
		ranlabg multig planarg gentourng linegraphg watercluster2 dretodot \
		subdivideg vcolg delptg cubhamg twohamg hamheuristic converseg \
		genspecialg genbgL \
		copyg listg labelg dretog amtog geng complg showg NRswitchg \
		dreadnaut

	dodoc README formats.txt nug*.pdf
}
