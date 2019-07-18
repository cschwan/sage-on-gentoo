# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_P="SYM$(ver_rs 1- '_')"

DESCRIPTION="A collection of routine to handle a variety of topics"
HOMEPAGE="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/index.html"
SRC_URI="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/${MY_P}_tar.gz -> ${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
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

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt ./ || die "failed to copy CMakeList.txt"

	cmake-utils_src_prepare
}

src_configure() {
	if use doc; then
		DOCS+=( "${S}"/*.doc )
	fi

	local mycmakeargs=(-DBUILD_SHARED_LIBS=ON)

	cmake-utils_src_configure
}
