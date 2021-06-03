# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="System for computational discrete algebra. Meta package."
HOMEPAGE="https://www.gap-system.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug emacs memcheck readline valgrind vim-syntax"
REQUIRED_USE="valgrind? ( memcheck )"

MINIMUM_PKGS="
	>=dev-gap/GAPDoc-1.6.4
	>=dev-gap/primgrp-3.4.1
	>=dev-gap/SmallGrp-1.4.1
	>=dev-gap/transgrp-2.0.5"

RDEPEND="
	sci-mathematics/gap-core[debug=,emacs=,memcheck=,readline=,valgrind=,vim-syntax=]
	${MINIMUM_PKGS}
"

REQUIRED_USE="?? ( memcheck valgrind )"
