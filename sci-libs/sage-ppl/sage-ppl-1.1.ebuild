# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils multilib

DESCRIPTION="The Parma Polyhedra Library provides numerical abstractions for analysis of complex systems"
HOMEPAGE="http://bugseng.com/products/ppl"
MY_PN=ppl
MY_P="${MY_PN}-${PV}"
SRC_URI="http://bugseng.com/products/ppl/download/ftp/releases/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-macos ~x64-macos ~ppc-macos"
IUSE="doc lpsol pch static-libs test"
S="${WORKDIR}/${MY_P}"

RDEPEND=">=dev-libs/gmp-4.1.3[cxx]
	lpsol? ( sci-mathematics/glpk )"
DEPEND="${RDEPEND}
	sys-devel/m4"

pkg_setup() {
	if use test; then
		ewarn "The PPL testsuite will be run."
		ewarn "Note that this can take several hours to complete on a fast machine."
	fi
}

src_configure() {
	econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir)/ppl1 \
		--includedir="${EPREFIX}"/usr/include/ppl1 \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--datadir="${EPREFIX}"/usr/share/ppl1 \
		--disable-debugging \
		--disable-optimization \
		--program-suffix=-1.0 \
		$(use_enable doc documentation) \
		$(use_enable lpsol ppl_lpsol) \
		$(use_enable pch) \
		$(use_enable static-libs static) \
		--enable-interfaces="c cxx" \
		$(use test && echo --enable-check=quick)
}

src_test() {
	# default src_test runs with -j1, overriding it here saves about
	# 30 minutes and is recommended by upstream
	if emake -j1 check -n &> /dev/null; then
		emake check || die "tests failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die

	local docsdir="${ED}/usr/share/doc/${PF}"
	rm "${docsdir}"/gpl* "${docsdir}"/fdl* || die
	rm -rf "${ED}"/usr/share/man || die

	if ! use doc; then
		rm -r "${docsdir}"/*-html/ || die
	fi

	dodoc NEWS README* STANDARDS TODO
}
