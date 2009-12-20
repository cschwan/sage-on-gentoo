# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

EAPI=2
DESCRIPTION="A collection of routine to handle a variety of topics"
HOMEPAGE="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/index.html"
MY_P=SYM$(replace_all_version_separators '_')
SRC_URI="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/${MY_P}_tar.gz -> ${MY_P}.tar.gz"

MY_P=SYM$(replace_all_version_separators ' _')

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RESTRICT="mirror"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	# symmetrica by itself is just a bunch of files and a few headers
	# plus documentation that you can use as you wish in your programs.
	# For sage and ease of use we make it into a library with the following
	# makefile (developped by F. Bissey and T. Abbott (sage on debian).
	cp "${FILESDIR}/makefile" "${S}/makefile"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc README || die "dodoc failed"

	# symmetrica's documentation are just text files with a ".doc" extension.
	if use doc ; then
		dodoc *.doc || die "dodoc failed"
	fi
}
