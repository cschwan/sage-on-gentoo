# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

DESCRIPTION="On-Line Encyclopedia of Integer Sequences (OEIS) (TM) for Sage"
HOMEPAGE="http://www.sagemath.org http://www.research.att.com/~njas/sequences"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror"

src_unpack() {
	wget http://www.research.att.com/~njas/sequences/names.gz \
		|| die "failed to download 'names' file"
	wget http://www.research.att.com/~njas/sequences/stripped.gz \
		|| die "failed to download 'stripped' file"

	gzip -d names.gz || die "failed to un-zip 'names' file"
	gzip -d stripped.gz || die "failed to un-zip 'stripped' file"
}

src_prepare() {
	bzip2 names || die "failed to compress 'names'"
	bzip2 stripped || die "failed to compress 'stripped'"

	mv names.bz2 sloane-names.bz2 || die "failed to rename 'names' file"
	mv stripped.bz2 sloane-oeis.bz2 || die "failed to rename 'stripped' file"
}

src_install() {
	insinto /usr/share/sage/data/sloane
	doins sloane-names.bz2 sloane-oeis.bz2 || die
}
