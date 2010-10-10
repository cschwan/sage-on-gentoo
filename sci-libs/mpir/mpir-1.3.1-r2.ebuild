# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils autotools

DESCRIPTION="MPIR is a library for arbitrary precision integer arithmetic
derived from version 4.2.1 of gmp"
HOMEPAGE="http://www.mpir.org/"
SRC_URI="http://www.mpir.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux"
IUSE="+cxx cpudetection"

RESTRICT="mirror"

# TODO: check if yasm is needed on x86
DEPEND="x86? ( dev-lang/yasm )
	amd64? ( dev-lang/yasm )"
RDEPEND=""

src_prepare(){
	# remove yasm and thus prevent eautoreconf to run in it
	rm -rf yasm || die "rm failed"

	# do not build yasm, use portage yasm instead
	epatch "${FILESDIR}"/${PN}-1.3.0-yasm.patch

	# do not use ABI variable, use MPIRABI instead
	epatch "${FILESDIR}"/${PN}-1.3.0-ABI-multilib.patch

	ebegin "Patching assembler files to remove executable sections"

	# TODO: report this to upstream
	# TODO: apply patch for all files ?
	# TODO: why does the as-style patch work (does mpir really use yasm ??)
	for i in $(find . -type f -name '*.asm') ; do
		# TODO: why does cat not work without echo ??? Something is wrong here
		echo $i >/dev/null
		cat >> $i <<-EOF
			#if defined(__linux__) && defined(__ELF__)
			.section .note.GNU-stack,"",%progbits
			#endif
		EOF
	done

	for i in $(find . -type f -name '*.as') ; do
		# TODO: why does cat not work without echo ??? Something is wrong here
		echo $i >/dev/null
		cat >> $i <<-EOF
			%ifidn __OUTPUT_FORMAT__,elf
			section .note.GNU-stack noalloc noexec nowrite progbits
			%endif
		EOF
	done

	eend

	eautoreconf
}

src_configure() {
	# beware that cpudetection aka fat binaries is x86/amd64 only.
	# Place mpir in profiles/arch/$arch/package.use.mask when making it
	# available on $arch.
	econf $(use_enable cxx) \
		$(use_enable cpudetection fat) \
		|| "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README NEWS || die "dodoc failed"
}
