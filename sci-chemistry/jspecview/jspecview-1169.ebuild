# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils java-pkg-2 java-ant-2 subversion

MY_P=""
MY_PN="JSpecView"
MY_BUILDVERSION="2.0.10076"
MY_APPLET_BUILDVERSION="2.0.10077"
DESCRIPTION="Spectroscopy Viewer"

HOMEPAGE="http://sourceforge.net/projects/jspecview/"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

ESVN_REPO_URI="svn://svn.code.sf.net/p/jspecview/svn/dev2"
ESVN_REVISION="1169"

LICENSE="LGPL-2"
S="${WORKDIR}/${P}"

RESTRICT="mirror"

IUSE="applet"

SLOT="0"

COMMON_DEP="dev-java/itext:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

pkg_setup() {
	java-pkg-2_pkg_setup
}

src_prepare() {

	cd "${S}/${MY_PN}"
	edos2unix build.xml
	epatch "${FILESDIR}/${P}_build.xml.patch" || die

	rm -v build/*.jar || die
	cd libs

# We still have to use netscape.jar on amd64 until a nice way to include plugin.jar comes along.
	if use amd64; then
		mv -v netscape.jar netscape.tempjar || die "Failed to move netscape.jar."
		rm -v *.jar || die "Failed to remove jars."
		mv -v netscape.tempjar netscape.jar || die "Failed to move netscape.tempjar."
	fi

	java-pkg_jar-from itext iText.jar itext-1.4.5-min.jar
}

src_compile() {
	cd "${S}/${MY_PN}Lib"
	eant
	cd "${S}/${MY_PN}"
	eant make-application-jar
	if use applet; then
		eant make-signed-applet-jar
	fi
}

src_install() {
	java-pkg_newjar "${S}/${MY_PN}/build/jspecview.app.${MY_BUILDVERSION}.jar" "jspecview.jar"
	if use applet; then
		java-pkg_newjar "${S}/${MY_PN}/build/jspecview.applet.${MY_APPLET_BUILDVERSION}.jar" "jspecview-applet.jar"
		java-pkg_newjar "${S}/${MY_PN}/build/jspecview.applet.signed.${MY_APPLET_BUILDVERSION}.jar" "jspecview-applet-signed.jar"
	fi
}
