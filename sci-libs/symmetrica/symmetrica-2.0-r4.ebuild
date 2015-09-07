# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils base multilib toolchain-funcs versionator

MY_P="SYM$(replace_all_version_separators '_')"

DESCRIPTION="A collection of routine to handle a variety of topics"
HOMEPAGE="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/index.html"
SRC_URI="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/${MY_P}_tar.gz -> ${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x64-macos"
IUSE="doc"

# test program does not stop
RESTRICT="mirror test"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

DOCS=( README )

PATCHES=(
	"${FILESDIR}/${P}"-banner.patch
	"${FILESDIR}/${P}"-freeing_errors.patch
	"${FILESDIR}/${P}"-function_names.patch
	"${FILESDIR}/${P}"-integersize.patch
	)

pkg_setup() {
	export CC=$(tc-getCC)
}

src_prepare() {
	base_src_prepare
	# symmetrica by itself is just a bunch of files and a few headers plus
	# documentation that you can use as you wish in your programs. For sage and
	# ease of use we make it into a library with the following makefile
	# (developed by F. Bissey and T. Abbott (sage on debian)).
	if  [[ ${CHOST} == *-darwin* ]] ; then
		cp "${FILESDIR}"/makefile-macos "${S}"/makefile \
			|| die "faile to copy makefile"
	else
		cp "${FILESDIR}"/makefile "${S}"/makefile \
			|| die "faile to copy makefile"
	fi

	# do not install static library
	sed -i "s:libsymmetrica\.a ::" makefile \
		|| die "failed to remove static library"
}

src_compile() {
	# set CC to make symmetrica work with ccache
	emake sharedlib
}

src_install() {
	export PREFIX="${EPREFIX}"/usr
	export LIBDIR=$(get_libdir)

	default_src_install

	# symmetrica's documentation are just text files with a ".doc" extension.
	if use doc ; then
		dodoc *.doc
	fi
}
