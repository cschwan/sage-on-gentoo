# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="threejs"
MY_P="${MY_PN}-r${PV}"
DESCRIPTION="JavaScript 3D library"
HOMEPAGE="https://threejs.org/"
SRC_URI="mirror://sageupstream/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND="!<sci-mathematics/sage-8.4"
RDEPEND="${DEPEND}"

DOCS=(
	LICENSE
)

S="${WORKDIR}"

src_install(){
	default
	insinto /usr/share/sage/threejs
	doins -r build
	doins -r examples
}
