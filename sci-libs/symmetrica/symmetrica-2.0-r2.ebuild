# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils multilib toolchain-funcs versionator

MY_P="SYM$(replace_all_version_separators '_')"

DESCRIPTION="A collection of routine to handle a variety of topics"
HOMEPAGE="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/index.html"
SRC_URI="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/${MY_P}_tar.gz -> ${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc"

# test program does not stop
RESTRICT="mirror test"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	# symmetrica by itself is just a bunch of files and a few headers plus
	# documentation that you can use as you wish in your programs. For sage and
	# ease of use we make it into a library with the following makefile
	# (developped by F. Bissey and T. Abbott (sage on debian).
	if  [[ ${CHOST} == *-darwin* ]] ; then
		cp "${FILESDIR}"/makefile-macos "${S}"/makefile || die "faile to copy makefile"
	else
		cp "${FILESDIR}"/makefile "${S}"/makefile || die "faile to copy makefile"
	fi

	# fix macros.h - does not include def.h which results in INT not defined
	epatch "${FILESDIR}"/${P}-fix-missing-typedef.patch

	# do not display symmetrica's banner
	sed -i "s:INT no_banner = FALSE:INT no_banner = TRUE:g" de.c \
		|| die "failed to patch banner away"

	# do not install static library
	sed -i "s:libsymmetrica\.a ::" makefile \
		|| die "failed to remove static library"
}

src_compile() {
	# set cc to make symmetrica work with ccache
	emake CC=$(tc-getCC) LIBDIR=$(get_libdir) sharedlib || die
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR=$(get_libdir) install || die

	dodoc README || die

	# symmetrica's documentation are just text files with a ".doc" extension
	if use doc ; then
		dodoc *.doc || die
	fi
}
