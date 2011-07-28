# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils java-pkg-2 java-ant-2

MY_PN="jmol"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Jmol is a java molecular viever for 3-D chemical structures."
SRC_URI="mirror://sourceforge/jmol/Jmol/Version%2012.0/Version%2012.0.30/Jmol-${PV}-full.tar.gz"
HOMEPAGE="http://jmol.sourceforge.net/"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"
S="${WORKDIR}/${MY_P}"

RESTRICT="mirror"

IUSE=""

SLOT="0"

COMMON_DEP="dev-java/commons-cli:1
	dev-java/itext:0
	sci-libs/jmol-acme:0
	sci-libs/vecmath-objectclub:0"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

pkg_setup() {
	java-pkg-2_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}/${MY_PN}-nointl.patch
	epatch "${FILESDIR}"/${PV}/${MY_PN}-manifest.patch

	# Jmol.js-12.0.45 patch thanks to Steve
	edos2unix Jmol.js
	epatch "${FILESDIR}"/${PN}-Jmol.js-12.0.45-unix.patch

	mkdir "${S}"/selfSignedCertificate || die "Failed to create Cert directory."
	cp "${FILESDIR}"/selfSignedCertificate.store "${S}"/selfSignedCertificate/ \
		|| die "Failed to install Cert file."

	rm -v "${S}"/*.jar "${S}"/plugin-jars/*.jar || die
	cd "${S}/jars"

# We still have to use netscape.jar on amd64 until a nice way to include plugin.jar comes along.
	if use amd64; then
		mv -v netscape.jar netscape.tempjar || die "Failed to move netscape.jar."
		rm -v *.jar *.tar.gz || die "Failed to remove jars."
		mv -v netscape.tempjar netscape.jar || die "Failed to move netscape.tempjar."
	fi

	java-pkg_jar-from vecmath-objectclub vecmath-objectclub.jar vecmath1.2-1.14.jar
	java-pkg_jar-from itext iText.jar itext-1.4.5.jar
	java-pkg_jar-from jmol-acme jmol-acme.jar Acme.jar
	java-pkg_jar-from commons-cli-1 commons-cli.jar commons-cli-1.0.jar
	java-pkg_jar-from junit junit.jar junit.jar

	mkdir -p "${S}/build/appjars" || die
}

src_compile() {
	# prevent absorbing dep's classes
	eant -Dlibjars.uptodate=true main
}

src_install() {
	insinto "${JAVA_PKG_SHAREPATH}"
	doins Jmol.js build/Jmol.jar build/JmolApplet*.jar applet.classes
	doins -r build/applet-classes/*
	doins -r build/appletjars/*
	doins "${FILESDIR}"/caffeine.xyz "${FILESDIR}"/index.html
}
