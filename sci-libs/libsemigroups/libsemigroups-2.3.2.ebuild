# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="libsemigroups is a C++ library for semigroups and monoids"
HOMEPAGE="https://libsemigroups.readthedocs.io/en/latest/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_popcnt"

DEPEND=">=dev-libs/libfmt-8.1.1"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-cpp/eigen-3.3.7"

src_configure() {
	# eigen is an automagical dependency
	econf \
		$(use_enable cpu_flags_x86_popcnt popcnt) \
		--enable-eigen \
		--with-external-eigen \
		--enable-fmt \
		--with-external-fmt
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
