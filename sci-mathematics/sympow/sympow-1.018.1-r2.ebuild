# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Computes special values of symmetric power elliptic curve L-functions"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sageupstream/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

RESTRICT=primaryuri

DEPEND=""
RDEPEND=">=sci-mathematics/pari-2.5.0"

PATCHES=(
	"${FILESDIR}"/execlp.patch
	"${FILESDIR}"/fpu.patch
	"${FILESDIR}"/initialize-tacks.patch
	)

pkg_setup(){
	# sympow doen't work with fma instructions.
	# Add flags to suppress them if available.
	if test-flag-CC -ffp-contract=on ; then
		append-cflags -ffp-contract=on
	else
		append-cflags $(test-flags-CC -mno-fused-madd)
	fi
}

src_prepare() {
	default

	local sharedir="${EPREFIX}"/usr/share/sympow

	# fix paths for gp scripts
	sed -i "s:standard\([123]\).gp:${sharedir}/standard\1.gp:g" generate.c \
		|| die "failed to patch gp script pathnames"

	# fix calls to itself - this one first:
	sed -i "s:\.\./sympow:sympow:g" generate.c \
		|| die "failed to patch call to binary"

	# now this:
	sed -i "s:whichexe :which :g" Configure \
		|| die "failed to patch Configure script"

	# now this:
	sed -i "s:\./sympow:sympow:g" disk.c new_data README \
		|| die "failed to patch call to binary"

	# rename script to avoid possible file conflicts
	sed -i "s:\"new_data\":\"sympow_new_data\":g" generate.c \
		|| die "failed to patch call to new_data script"

	# create wrapper script so that sympow may read and write data files
	cat > sympow_temp <<-EOF
		#!/bin/sh

		DATA="\${HOME}"/.sympow/datafiles

		if [ ! -d "\${DATA}" ]; then
		    mkdir -p "\${DATA}"
		    cp "${EPREFIX}"/usr/share/sympow/datafiles/* "\${DATA}"
		fi

		cd "\${HOME}"/.sympow
		exec sympow_bin "\$@"
	EOF

	chmod go+rx sympow_temp \
		|| die "failed to change permissions of wrapper script"
}

src_configure() {
	./Configure || die "failed to configure sources"
}

src_compile() {
	emake CC="$(tc-getCC)" OPT=
}

src_install() {
	# install and rename script
	newbin new_data sympow_new_data

	# install and rename binary
	newbin sympow sympow_bin

	# install wrapper script
	newbin sympow_temp sympow

	# install pari scripts and data
	insinto /usr/share/sympow
	doins *.gp
	doins -r datafiles

	# install docs
	dodoc README
}
