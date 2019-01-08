# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Meta package to install all sage optional gap packages"
HOMEPAGE="http://www.gap-system.org/Packages/"

GAP_VERSION=${PV}
LICENSE="metapackage"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-gap/aclib:${SLOT}
	dev-gap/Alnuth:${SLOT}
	dev-gap/autpgrp:${SLOT}
	dev-gap/crime:${SLOT}
	dev-gap/crystcat:${SLOT}
	dev-gap/ctbllib:${SLOT}
	dev-gap/design:${SLOT}
	dev-gap/factint:${SLOT}
	dev-gap/grape:${SLOT}
	dev-gap/guava:${SLOT}
	dev-gap/hap:${SLOT}
	dev-gap/HAPcryst:${SLOT}
	dev-gap/happrime:${SLOT}
	dev-gap/laguna:${SLOT}
	dev-gap/polycyclic:${SLOT}
	dev-gap/polymaking:${SLOT}
	dev-gap/sonata:${SLOT}
	dev-gap/toric:${SLOT}"

S="${WORKDIR}"

pkg_postinst() {
	einfo "This meta package currently doesn't install:"
	einfo "atlasrep and tomlib"
	einfo "There is an issue with atlasrep in that it tries to write"
	einfo "in a system location if installed a system package."
	einfo "Alternatively atlasrep can be installed safely"
	einfo "in a default user location. Namely ~/.gap/pkg, where"
	einfo "it will be happilly picked up by gap"
	einfo "tomlib is not installed because it depends on atlasrep"
	einfo "and can be installed in a user location the same way"
}
