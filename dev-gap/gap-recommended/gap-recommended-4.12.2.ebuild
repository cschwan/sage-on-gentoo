# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package pulling the recommended pkgs for gap"
HOMEPAGE="https://www.gap-system.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

# Apart from the packages from the minimal set needed to start gap,
# those are typically expected from a normal gap installation.
# They are listed in lib/package.gi in gap sources
# (or /usr/share/gap/lib/package.gi in a typical Gentoo installation).
# Look under "F  AutoloadPackages()"
# By default gap will complain if those are missing.
RECOMMENDED_PKGS="
	>=dev-gap/autpgrp-1.11
	>=dev-gap/Alnuth-3.2.1
	>=dev-gap/crisp-1.4.6
	>=dev-gap/ctbllib-1.3.4
	>=dev-gap/factint-1.6.3-r1
	>=dev-gap/fga-1.4.0-r4
	>=dev-gap/irredsol-1.4.4
	>=dev-gap/laguna-3.9.5
	>=dev-gap/polenta-1.3.10
	>=dev-gap/polycyclic-2.16-r1
	>=dev-gap/resclasses-4.7.3
	>=dev-gap/sophus-1.27
	>=dev-gap/tomlib-1.2.9-r1"

RDEPEND="
	~sci-mathematics/gap-${PV}
	${RECOMMENDED_PKGS}
"
