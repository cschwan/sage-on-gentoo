# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/mpc/mpc-0.9-r1.ebuild,v 1.3 2012/04/26 14:39:36 aballier Exp $

# Unconditional dependency of gcc.  Keep this set to 0.
EAPI="0"

inherit eutils libtool

DESCRIPTION="A library for multiprecision complex arithmetic with exact rounding."
HOMEPAGE="http://mpc.multiprecision.org/"
SRC_URI="http://www.multiprecision.org/mpc/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

DEPEND=">=dev-libs/gmp-4.3.2
	>=dev-libs/mpfr-2.4.2
	elibc_SunOS? ( >=sys-devel/gcc-4.5 )"
RDEPEND="${DEPEND}"

src_compile() {
	econf $(use_enable static-libs static) || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	use static-libs || rm "${ED:-${D}}"/usr/lib*/libmpc.la
	dodoc ChangeLog NEWS README TODO
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/libmpc.so.2
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libmpc.so.2
}
