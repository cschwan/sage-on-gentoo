# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Meta package to install all sage optional gap packages"
HOMEPAGE="https://www.gap-system.org/Packages/"

GAP_VERSION=${PV}
LICENSE="metapackage"
SLOT="0/${GAP_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-gap/aclib:${SLOT}
	dev-gap/cohomolo:${SLOT}
	dev-gap/corelg:${SLOT}
	dev-gap/crime:${SLOT}
	dev-gap/crystcat:${SLOT}
	dev-gap/design:${SLOT}
	dev-gap/gbnp:${SLOT}
	dev-gap/grape:${SLOT}
	dev-gap/guava:${SLOT}
	dev-gap/hap:${SLOT}
	dev-gap/HAPcryst:${SLOT}
	dev-gap/hecke:${SLOT}
	dev-gap/liealgdb:${SLOT}
	dev-gap/liering:${SLOT}
	dev-gap/liepring:${SLOT}
	dev-gap/loops:${SLOT}
	dev-gap/MapClass:${SLOT}
	dev-gap/nq:${SLOT}
	dev-gap/polymaking:${SLOT}
	dev-gap/qpa:${SLOT}
	dev-gap/quagroup:${SLOT}
	dev-gap/sla:${SLOT}
	dev-gap/sonata:${SLOT}
	dev-gap/toric:${SLOT}"

S="${WORKDIR}"

pkg_postinst() {
	einfo "This meta package currently doesn't install:"
	einfo "respn"
	einfo "I haven't packaged it as it lacks a license"
}
