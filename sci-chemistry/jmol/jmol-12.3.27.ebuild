# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WEBAPP_OPTIONAL="yes"

inherit eutils webapp java-pkg-2 java-ant-2

MY_P="Jmol"
MY_PN="jmol"

DESCRIPTION="Jmol is a java molecular viever for 3-D chemical structures."
SRC_URI="
	mirror://sourceforge/${PN}/${MY_P}-${PV}-full.tar.gz"

HOMEPAGE="http://jmol.sourceforge.net/"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"

IUSE="+client-only vhosts"

WEBAPP_MANUAL_SLOT="yes"
SLOT="0"

COMMON_DEP="sci-chemistry/sage-jmol-bin
	dev-java/commons-cli
	dev-java/itext:0
	sci-chemistry/jspecview
	sci-libs/jmol-acme
	sci-libs/vecmath-objectclub
	sci-libs/naga"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	!client-only? ( ${WEBAPP_DEPEND} )
	${COMMON_DEP}
	dev-java/saxon:6.5"

pkg_setup() {
	use client-only webapp_pkg_setup
	java-pkg-2_pkg_setup
}

src_prepare() {
	edos2unix build.xml
	epatch "${FILESDIR}"/${MY_PN}-12.3.27-nointl.patch

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
	java-pkg_jar-from jspecview jspecview.jar

	mkdir -p "${S}/build/appjars" || die
}

src_compile() {
	# prevent absorbing dep's classes
	eant -Dlibjars.uptodate=true main
}

src_install() {
	insinto "${JAVA_PKG_SHAREPATH}"

	java-pkg_dojar build/Jmol.jar build/JmolData.jar
	dohtml -r  build/doc/
	dodoc *.txt doc/*license*

	java-pkg_dolauncher ${PN} --main org.openscience.jmol.app.Jmol \
		--java_args "-Xmx512m"

	if ! use client-only ; then
		webapp_src_preinst || die "Failed webapp_src_preinst."
		cmd="cp Jmol.js build/Jmol.jar "${ED}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp build/JmolApplet*.jar "${ED}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp applet.classes "${ED}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp -r build/classes/* "${ED}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp -r build/appletjars/* "${ED}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp "${FILESDIR}"/caffeine.xyz "${ED}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp "${FILESDIR}"/index.html "${ED}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."

		webapp_src_install || die "Failed running webapp_src_install"
	fi
}

pkg_postinst() {

	if ! use client-only ; then
		webapp_pkg_postinst || die "webapp_pkg_postinst failed"
	fi

}

pkg_prerm() {

	if ! use client-only ; then
		webapp_pkg_prerm || die "webapp_pkg_prerm failed"
	fi

}
