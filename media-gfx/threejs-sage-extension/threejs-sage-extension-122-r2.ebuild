# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="threejs"
MY_P="${MY_PN}-r${PV}"
DESCRIPTION="JavaScript 3D library"
HOMEPAGE="https://github.com/sagemath/threejs-sage"
SRC_URI="https://github.com/sagemath/threejs-sage/archive/r${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

DOCS=(
	LICENSE
	README.md
)

S="${WORKDIR}/threejs-sage-r${PV}"

src_install(){
	default
	insinto /usr/share/sage/threejs
	doins version
	insinto usr/share/sage/threejs/r${PV}
	doins -r build/*
}
