# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="System for computational discrete algebra. Meta package."
HOMEPAGE="https://www.gap-system.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug emacs memcheck readline +recommended_pkgs valgrind vim-syntax"
REQUIRED_USE="valgrind? ( memcheck )"

MINIMUM_PKGS="
	>=dev-gap/GAPDoc-1.6.3
	>=dev-gap/primgrp-3.4.0
	>=dev-gap/SmallGrp-1.4.1
	>=dev-gap/transgrp-2.0.5"

RECOMMENDED_PKGS="
	>=dev-gap/autpgrp-1.10.2
	>=dev-gap/Alnuth-3.1.2
	>=dev-gap/crisp-1.4.5
	>=dev-gap/ctbllib-1.2_p2
	>=dev-gap/factint-1.6.3
	>=dev-gap/fga-1.4.0
	>=dev-gap/irredsol-1.4
	>=dev-gap/laguna-3.9.3
	>=dev-gap/polenta-1.3.9
	>=dev-gap/polycyclic-2.15.1
	>=dev-gap/resclasses-4.7.2
	>=dev-gap/sophus-1.24
	>=dev-gap/tomlib-1.2.9"

RDEPEND="
	sci-mathematics/gap-core[debug=,emacs=,memcheck=,readline=,recommended_pkgs=,valgrind=,vim-syntax=]
	${MINIMUM_PKGS}
	recommended_pkgs? ( ${RECOMMENDED_PKGS} )
"

REQUIRED_USE="?? ( memcheck valgrind )"
