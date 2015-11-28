# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GIT_SHA1="3ef9645373cf8a0d57d4cd8b15bcf83e5e7d5a19"

inherit vim-plugin vcs-snapshot

DESCRIPTION="vim plugin: GAP template engine syntax highlighting, indention"
HOMEPAGE="https://github.com/petRUShka/vim-gap"
SRC_URI="https://github.com/petRUShka/${PN}/archive/${GIT_SHA1}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

VIM_PLUGIN_MESSAGES="filetype"

src_prepare() {
	# Remove defunct GAP syntax checker for Syntastic
	rm -r bin/ syntax_checkers/ || die
}
