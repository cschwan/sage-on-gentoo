# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils versionator multilib

MY_P="SYM$(replace_all_version_separators '_')"

DESCRIPTION="A collection of routine to handle a variety of topics"
HOMEPAGE="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/index.html"
SRC_URI="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/${MY_P}_tar.gz -> ${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RESTRICT="mirror"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

DOCS=( README )

src_prepare() {
	# symmetrica by itself is just a bunch of files and a few headers plus
	# documentation that you can use as you wish in your programs. For sage and
	# ease of use we make it into a library with the following makefile
	# (developed by F. Bissey and T. Abbott (sage on debian)).
	cp "${FILESDIR}"/makefile "${S}"/makefile

	# fix macros.h - does not include def.h which results in INT not defined
	epatch "${FILESDIR}"/${P}-fix-missing-typedef.patch

	# do not display symmetrica's banner
	sed -i "s:INT no_banner = FALSE:INT no_banner = TRUE:g" de.c
}

src_install() {
	export LIBDIR=$(get_libdir)

	default_src_install

	# symmetrica's documentation are just text files with a ".doc" extension.
	if use doc ; then
		dodoc *.doc
	fi
}
