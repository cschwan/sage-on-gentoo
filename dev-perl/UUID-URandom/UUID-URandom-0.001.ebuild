# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.001
inherit perl-module

DESCRIPTION="thin wrapper around Crypt::URandom"
HOMEPAGE="https://metacpan.org/pod/UUID::URandom"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Crypt-URandom"
DEPEND="${RDEPEND}"
