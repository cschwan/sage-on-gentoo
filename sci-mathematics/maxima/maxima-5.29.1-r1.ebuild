# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/maxima/maxima-5.29.1.ebuild,v 1.1 2012/12/14 09:55:25 grozin Exp $

EAPI=3

inherit autotools elisp-common eutils

DESCRIPTION="Free computer algebra environment based on Macsyma"
HOMEPAGE="http://maxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

# Supported lisps (the first one is the default)
LISPS=(     sbcl cmucl gcl             ecls clozurecl clisp )
# . - just dev-lisp/<lisp>, <version> - >= dev-lisp/<lisp>-<version>
MIN_VER=(   .    .     2.6.8_pre[ansi] 12.12.1   .         .     )
# <lisp> supports readline: . - no, y - yes
SUPP_RL=(   .    .     y               .    .         y     )
# . - just --enable-<lisp>, <flag> - --enable-<flag>
CONF_FLAG=( .    .     .               ecl  ccl       .     )

IUSE="latex emacs tk nls unicode xemacs X ${LISPS[*]}"

# Languages
LANGS="es pt pt_BR"
for lang in ${LANGS}; do
	IUSE="${IUSE} linguas_${lang}"
done

RDEPEND="X? ( x11-misc/xdg-utils
		 sci-visualization/gnuplot[gd]
		 tk? ( dev-lang/tk ) )
	latex? ( virtual/latex-base )
	emacs? ( virtual/emacs
		latex? ( app-emacs/auctex ) )
	xemacs? ( app-editors/xemacs
		latex? ( app-emacs/auctex ) )"

PDEPEND="emacs? ( app-emacs/imaxima )"

# generating lisp dependencies
depends() {
	local LISP DEP
	LISP=${LISPS[$1]}
	DEP=${MIN_VER[$1]}
	if [ "${DEP}" = "." ]; then
		DEP="dev-lisp/${LISP}"
	else
		DEP=">=dev-lisp/${LISP}-${DEP}"
	fi
	if [ "${SUPP_RL[$1]}" = "." ]; then
		DEP="${DEP} app-misc/rlwrap"
	fi
	echo ${DEP}
}

n=${#LISPS[*]}
for ((n--; n >= 0; n--)); do
	LISP=${LISPS[${n}]}
	RDEPEND="${RDEPEND} ${LISP}? ( $(depends ${n}) )"
	if (( ${n} > 0 )); then
		DEF_DEP="${DEF_DEP} !${LISP}? ( "
	fi
done

DEF_DEP="${DEF_DEP} `depends 0`"

n=${#LISPS[*]}
for ((n--; n > 0; n--)); do
	DEF_DEP="${DEF_DEP} )"
done

unset LISP

RDEPEND="${RDEPEND}
	${DEF_DEP}"

DEPEND="${RDEPEND}
	sys-apps/texinfo"

TEXMF="${EPREFIX}"/usr/share/texmf-site

pkg_setup() {
	local n=${#LISPS[*]}

	for ((n--; n >= 0; n--)); do
		use ${LISPS[${n}]} && NLISPS="${NLISPS} ${n}"
	done

	if [ -z "${NLISPS}" ]; then
		ewarn "No lisp specified in USE flags, choosing ${LISPS[0]} as default"
		NLISPS=0
	fi
}

src_prepare() {
	# use xdg-open to view ps, pdf
	epatch "${FILESDIR}"/${PN}-xdg-utils.patch

	# Don't use lisp init files
	epatch "${FILESDIR}"/${P}.patch

	# ClozureCL (former OpenMCL) executable name is ccl
	epatch "${FILESDIR}"/${PN}-ccl.patch

	# make xmaxima conditional on tk (wish)
	epatch "${FILESDIR}"/${P}-wish.patch

	# don't install imaxima, since we have a separate package for it
	epatch "${FILESDIR}"/${PN}-imaxima.patch

	# remove rmaxima if not needed
	epatch "${FILESDIR}"/${PN}-rmaxima.patch

	# fix LDFLAGS handling in ecl (#378195)
	epatch "${FILESDIR}"/${PN}-ecl-ldflags.patch

	# workaround for the broken sbcl
	epatch "${FILESDIR}"/${P}-sbcl.patch

	# sage patches
	epatch "${FILESDIR}"/0001-taylor2-Avoid-blowing-the-stack-when-diff-expand-isn.patch
	epatch "${FILESDIR}"/maxima_bug_2526.patch
	epatch "${FILESDIR}"/undoing_true_false_printing_patch.patch

	# bug #343331
	rm share/Makefile.in || die
	rm src/Makefile.in || die
	touch src/*.mk
	touch src/Makefile.am
	eautoreconf
}

src_configure() {
	local CONFS CONF n lang
	for n in ${NLISPS}; do
		CONF=${CONF_FLAG[${n}]}
		if [ ${CONF} = . ]; then
			CONF=${LISPS[${n}]}
		fi
		CONFS="${CONFS} --enable-${CONF}"
	done

	# enable existing translated doc
	if use nls; then
		for lang in ${LANGS}; do
			if use "linguas_${lang}"; then
				CONFS="${CONFS} --enable-lang-${lang}"
				use unicode && CONFS="${CONFS} --enable-lang-${lang}-utf8"
			fi
		done
	fi

	econf ${CONFS} $(use_with tk wish) --with-lispdir="${SITELISP}"/${PN}
}

src_install() {
	einstall emacsdir="${ED}${SITELISP}/${PN}" || die "einstall failed"

	use tk && make_desktop_entry xmaxima xmaxima \
		/usr/share/${PN}/${PV}/xmaxima/maxima-new.png \
		"Science;Math;Education"

	if use latex; then
		insinto ${TEXMF}/tex/latex/emaxima
		doins interfaces/emacs/emaxima/emaxima.sty
	fi

	# do not use dodoc because interfaces can't read compressed files
	# read COPYING before attempt to remove it from dodoc
	insinto /usr/share/${PN}/${PV}/doc
	doins AUTHORS COPYING README README.lisps || die
	dodir /usr/share/doc
	dosym ../${PN}/${PV}/doc /usr/share/doc/${PF} || die

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/50maxima-gentoo.el || die
	fi

	# if we use ecls, build an ecls library for maxima
	if use ecls; then
		cd src
		mkdir ./lisp-cache
		ecl \
			-eval '(require `asdf)' \
			-eval '(setf asdf::*user-cache* (truename "./lisp-cache"))' \
			-eval '(load "maxima-build.lisp")' \
			-eval '(asdf:make-build :maxima :type :fasl :move-here ".")' \
			-eval '(quit)'
		ECLLIB=`ecl -eval "(princ (SI:GET-LIBRARY-PATHNAME))" -eval "(quit)"`
		insinto "${ECLLIB#${EPREFIX}}"
		newins maxima.system.fasb maxima.fas
	fi
}

pkg_preinst() {
	# some lisps do not read compress info files (bug #176411)
	local infofile
	for infofile in "${ED}"/usr/share/info/*.bz2 ; do
		bunzip2 "${infofile}"
	done
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use latex && mktexlsr
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use latex && mktexlsr
}
