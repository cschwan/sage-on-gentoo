# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIM_PLUGIN_MESSAGES=filetype

inherit vim-plugin vcs-snapshot

COMMIT_ID="3ef9645373cf8a0d57d4cd8b15bcf83e5e7d5a19"

DESCRIPTION="vim plugin: GAP syntax highlighting and indentation"
HOMEPAGE="https://github.com/petRUShka/vim-gap"
SRC_URI="https://github.com/petRUShka/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	default_src_prepare

	# Remove defunct GAP syntax checker for Syntastic.
	rm -r bin/ syntax_checkers/ || die

	# Disable default mappings to avoid conflicts.
	# See https://github.com/petRUShka/vim-gap/issues/1
	sed -i -e '/^[nv]\?map\b/s/^/"/g' ftplugin/gap.vim || die
}
