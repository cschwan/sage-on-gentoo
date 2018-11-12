# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="ThebeLab: turning static HTML pages into live documents"
HOMEPAGE="https://github.com/minrk/thebelab"
SRC_URI="https://github.com/minrk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/notebook"

src_install(){
	insinto /usr/share/jupyter/nbextensions/"${PN}"
	doins src/*
}
