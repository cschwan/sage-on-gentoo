# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib python sage flag-o-matic

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography and numerical computation"
HOMEPAGE="http://www.sagemath.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples latex wiki X java"

# TODO: check dependencies use flagged packages
CDEPEND=">=app-arch/bzip2-1.0.5
	>=net-zope/zodb-3.7.0
	>=net-zope/zope-i18nmessageid-3.5.0
	>=net-zope/zope-testbrowser-3.7.0
	>=sci-mathematics/rubiks-20070912_p10
	~sci-mathematics/sage-core-${PV}
	~sci-mathematics/sage-data-${PV}
	~sci-mathematics/sage-extcode-${PV}
	~sci-mathematics/sage-notebook-0.8[java=]
	~sci-mathematics/sage-singular-3.1.0.4.20100214
	virtual/cblas"

DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}
	>=dev-python/gdmodule-0.56
	>=dev-python/imaging-1.1.6
	>=dev-python/jinja-1.2
	~dev-python/pexpect-2.0
	>=dev-python/mpmath-0.14
	>=dev-python/matplotlib-0.99.1
	~dev-python/networkx-1.0.1
	>=dev-python/ipython-0.9.1
	>=dev-python/pycrypto-2.0.1
	>=dev-python/python-gnutls-1.1.4
	sci-mathematics/sage-doc
	examples? ( ~sci-mathematics/sage-examples-${PV} )
	latex? ( ~sci-mathematics/sage-latex-2.2.5 )
	>=sci-mathematics/gap-4.4.12
	>=sci-mathematics/gap-guava-3.4
	~sci-mathematics/maxima-5.20.1[ecl]
	>=sci-mathematics/genus2reduction-0.3
	>=sci-mathematics/lcalc-1.23[pari]
	>=sci-mathematics/sympow-1.018
	>=sci-libs/cddlib-094f
	>=sci-mathematics/gfan-0.4
	>=media-gfx/tachyon-0.98
	>=sci-mathematics/flintqs-20070817_p4
	>=sci-mathematics/palp-1.1
	~sci-libs/scipy-0.7.1
	~dev-python/sympy-0.6.6
	>=dev-python/cvxopt-0.9
	dev-python/sqlalchemy[sqlite]
	>=dev-python/sphinx-0.6.3
	wiki? ( ~www-apps/sage-moin-1.9.1_p1 )
	java? ( >=virtual/jre-1.6 )"

src_install() {
	# TODO: grab icon from official site

	if use X ; then
		# unpack icon
		cp 	"${FILESDIR}"/${PN}.svg.bz2 . || die "cp failed"
		bzip2 -d ${PN}.svg.bz2 || die "tar failed"

		# install icon
		doicon ${PN}.svg || die "doicon failed"

		# make .desktop file
		cat > sage-sage.desktop <<-EOF
			[Desktop Entry]
			Name=Sage Shell
			Type=Application
			Comment=${DESCRIPTION}
			Exec=${PN}
			TryExec=${PN}
			Icon=${PN}
			Categories=Education;Science;Math;
			Terminal=true
		EOF

		# install .desktop file
		domenu sage-sage.desktop || die "domenu failed"
	fi
}

pkg_postinst() {
	# TODO: check if this is still needed

	# make sure files are correctly setup in the new location by running sage
	# as root. This prevent nasty message to be presented to the user.
	"${SAGE_ROOT}"/sage -c
}
