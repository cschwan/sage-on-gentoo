# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Meta package to install all sage optional gap packages"
HOMEPAGE="http://www.gap-system.org/Packages/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="~dev-gap/aclib-1.2
	~dev-gap/Alnuth-3.0.0
	~dev-gap/autpgrp-1.5
	~dev-gap/crime-1.4
	~dev-gap/crystcat-1.1.6
	~dev-gap/ctbllib-1.2_p2
	~dev-gap/design-1.6
	~dev-gap/factint-1.5.3
	~dev-gap/grape-4.7
	~dev-gap/GUAVA-3.13
	~dev-gap/hap-1.11
	~dev-gap/HAPcryst-0.1.11
	~dev-gap/happrime-0.6
	~dev-gap/laguna-3.7.0
	~dev-gap/polycyclic-2.11
	~dev-gap/polymaking-0.8.1
	~dev-gap/sonata-2.8
	~dev-gap/toric-1.8"

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
