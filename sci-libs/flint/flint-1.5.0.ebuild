# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib toolchain-funcs

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="qs openmp ntl doc"

DEPENDS="ntl? ( dev-libs/ntl )
		dev-libs/gmp"
RDEPENDS="ntl? ( dev-libs/ntl )
		dev-libs/gmp"

pkg_setup() {
	if ( use openmp ) then
	   if ( $(tc-getCC)$ == *gcc* ) then
	      if ( $(gcc-major-version)$(gcc-minor-version) -lt 43 ) then
		  eerror "You are using gcc and OpenMP is only available with gcc >= 4.2 "
		  eerror "mathgl requires at least gcc >= 4.3"
		  eerror "If you want to use gcc you also need to enable the openmp useflag for gcc"
		  die "wrong compiler version"
	      elif ( ! built_with_use sys-devel/gcc openmp ) then
		  eerror "You are using gcc, gcc needs to be build with the openmp useflag"
		  die "Wrong configuration for gcc"
	      fi
	    fi
	    einfo "You are not using gcc"
	    einfo "You should ensure that your compiler is providing support for openmp"
	fi
}

src_prepare() {
	sed -i s/"-shared -o libflint.so"/"-shared -Wl,-soname,libflint.so -o libflint.so"/ makefile
	sed -i s:"CFLAGS = \$(INCS) \$(FLINT_TUNE) -O2":" ": makefile
	if( use openmp ); then
	  sed -i s:"CFLAGS2 = \$(INCS) \$(FLINT_TUNE) -O2":"CFLAGS2 = \$(CFLAGS) -openmp ": makefile
	else
	  sed -i s:"CFLAGS2 = \$(INCS) \$(FLINT_TUNE) -O2":"CFLAGS2 = \$(CFLAGS) ": makefile
	fi
	sed -i s:"\$(CPP) \$(CFLAGS)":"\$(CPP) \$(CXXFLAGS)": makefile
}

src_compile() {
	export FLINT_GMP_INCLUDE_DIR="/usr/include"
	export FLINT_GMP_LIB_DIR=$(get_libdir)
	export FLINT_NTL_LIB_DIR=$(get_libdir)
	export FLINT_LINK_OPTIONS="${LDFLAGS}"
	export FLINT_CC=$(tc-getCC)
	export FLINT_CPP=$(tc-getCXX)
	export FLINT_LIB="libflint.so"

	emake library || die "Building flint shared library failed!"

	if( use qs ); then
		emake QS || die "Building flintQS failed!"
	fi

	if( use ntl ); then
		$(tc-getCXX) ${CXXFLAGS} -fPIC -c NTL-interface.cpp
		$(tc-getAR) q libFLINT_NTL-interface.a  NTL-interface.o
	fi
}

src_install(){
	dolib.so libflint.so || die "installation of library failed!"

	insinto /usr/include/FLINT
	doins *.h || die "installation of headers failed!"

	if( use ntl ); then
	  dolib.a libFLINT_NTL-interface.a
	fi

	if( use qs ); then
		dobin mpQS || die "installation of mpQS failed!"
	fi

	if( use doc ); then
	  insinto /usr/share/doc/${PF}
	  doins doc/*.pdf || die "Failed to install docs"
	fi
}
