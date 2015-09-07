# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

MY_PN="jmol"
MY_P=${MY_PN}-${PV}_2014.08.03
DESCRIPTION="Jmol is a java molecular viever for 3-D chemical structures."
HOMEPAGE="http://jmol.sourceforge.net/"
SRC_URI="mirror://sageupstream/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
iUSE=""

DEPEND="!sci-chemistry/jmol"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7"

QA_PREBUILT="*"

S="${WORKDIR}"/${MY_P}

src_prepare(){
	rm jmol.bat jmol.mac
}

src_compile() { :; }

src_install() {
	dodoc *.txt || die

	# The order seems to be important, Jmol.jar needs to be first. 
	# Using *.jar puts JSpecView.jar first and leads to breakages.
	java-pkg_dojar Jmol.jar JmolData.jar JmolLib.jar JSpecView.jar
	java-pkg_dolauncher ${MY_PM} --main org.openscience.jmol.app.Jmol \
		--java_args "-Xmx512m"
	insinto /usr/share/${PN}/lib/appletweb
	doins "${FILESDIR}"/*
	insinto /usr/share/jsmol
	doins -r jsmol/*
}
