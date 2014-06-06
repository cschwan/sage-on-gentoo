# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils java-pkg-2 java-ant-2

MY_P="Jmol"
MY_PN="jmol"
DESCRIPTION="Jmol is a java molecular viever for 3-D chemical structures."

SRC_URI="
	mirror://sourceforge/${MY_PN}/${MY_P}-${PV}-full.tar.gz"

HOMEPAGE="http://jmol.sourceforge.net/"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"
S="${WORKDIR}/${MY_PN}-${PV}"

RESTRICT="mirror"

#IUSE="sage"
IUSE=""

SLOT="0"

COMMON_DEP="dev-java/commons-cli:1
	dev-java/itext:0
	sci-chemistry/jspecview
	sci-libs/jmol-acme:0
	sci-libs/vecmath-objectclub:0
	sci-libs/naga"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}
	dev-java/saxon:6.5"

pkg_setup() {
	java-pkg-2_pkg_setup
}

src_prepare() {
	edos2unix build.xml
#	epatch "${FILESDIR}"/${MY_PN}-${PV}-nointl.patch
	epatch "${FILESDIR}"/${MY_PN}-12.3.27-nointl.patch

	# Jmol.js-12.3.27 patch
	edos2unix Jmol.js
	cp Jmol.js Jmol.js.orig
	epatch "${FILESDIR}"/${PN}-Jmol.js-12.3.27-unix.patch

	# hack to add JmolHelp.html for trac 12299
#	if use sage; then
#		epatch "${FILESDIR}"/jmol-add-help.patch || die
#	fi

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
	java-pkg_jar-from naga naga.jar naga-2_1-r42.jar
	java-pkg_jar-from saxon-6.5 saxon.jar
	java-pkg_jar-from junit junit.jar junit.jar
	java-pkg_jar-from jspecview jspecview.jar JSpecView.jar

	mkdir -p "${S}/build/appjars" || die
}

src_compile() {
	# prevent absorbing dep's classes
#	eant -Dlibjars.uptodate=true main
	eant main
}

src_install() {
	java-pkg_init_paths_
	insinto "${JAVA_PKG_SHAREPATH}"
#	if use sage; then
#		doins JmolHelp.html
#	fi
	doins Jmol.js build/Jmol.jar build/JmolData.jar build/JmolApplet*.jar applet.classes
#	doins appletweb/*.jar
	doins -r build/applet-classes/*
	doins -r build/appletjars/*
	doins -r build/classes/*
	doins "${FILESDIR}"/caffeine.xyz "${FILESDIR}"/index.html
}
