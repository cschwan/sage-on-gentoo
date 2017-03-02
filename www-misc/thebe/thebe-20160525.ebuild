# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Thebe is a Jupyter javascript plugin for static sites"
HOMEPAGE="https://oreillymedia.github.io/thebe/"
HASH="9624e0a07a00026103dce1a3e32bbfbf90a6d0f9"
SRC_URI="https://github.com/oreillymedia/thebe/archive/${HASH}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${HASH}"

src_install(){
	insinto /usr/share/"${PN}"
	newins static/main-built.js thebe.js
}
