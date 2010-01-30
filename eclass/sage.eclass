# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

# @ECLASS: sage.eclass
# @MAINTAINER:
# Francois Bissey <f.r.bissey@massey.ac.nz>
# Christopher Schwan <cschwan@students.uni-mainz.de>
#
# Original authors: Francois Bissey <f.r.bissey@massey.ac.nz>
#	Christopher Schwan <cschwan@students.uni-mainz.de>
# @BLURB: Tools to ease the compilation of Sage's spkg-packages and Sage itself
# @DESCRIPTION:
# The sage eclass serves two purposes:
# Fistly, it eases the compilation of Sage itself by providing functions for
# patching and modifying its *.spkg-files.
#
# Secondly, in order to install packages from Sage's tarball it provides a
# src_unpack function for automatic unpacking. You must set the following two
# variables to make use of this:
#
# @CODE
# SAGE_VERSION
# SAGE_PACKAGE
# @CODE
# @EXAMPLE:
# The following is a minimal version of the flintqs ebuild and shows the usage
# for packages included in Sage's tarball:
#
# @CODE
# EAPI=2
#
# SAGE_VERSION="4.2.1"
# SAGE_PACKAGE="flintqs-20070817.p4"
#
# inherit eutils sage
#
# [..]
#
# src_prepare() {
# 	cp "${SAGE_FILESDIR}"/lanczos.h .
#
# 	[..]
# }
#
# [..]
# @CODE

inherit eutils

SPKG_URI="http://www.sagemath.org/packages/standard"

HOMEPAGE="http://www.sagemath.org/"
SRC_URI="mirror://sage/src/sage-${SAGE_VERSION}.tar"

RESTRICT="mirror"

# @ECLASS-VARIABLE: SAGE_ROOT
# @DESCRIPTION:
# Points to the directory where Sage will be installed to
SAGE_ROOT=/opt/sage

# @ECLASS-VARIABLE: SAGE_DATA
# @DESCRIPTION:
# Points to the directory where Sage's data files will be installed to
SAGE_DATA="${SAGE_ROOT}"/data

# @ECLASS-VARIABLE: SAGE_LOCAL
# @DESCRIPTION:
# Points to the directory where Sage's local directory will be
SAGE_LOCAL="${SAGE_ROOT}"/local

_SAGE_UNPACKED_SPKGS=( )

# TODO: Would be nice if this gets pulled into eutils.eclass!

# @FUNCTION: hg_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove Mercurial directories recursiveley.  Useful when a source tarball
# contains internal Mercurial directories.  Defaults to $PWD.
hg_clean() {
    [[ -z $* ]] && set -- .
    find "$@" -type d -name '.hg' -prune -print0 | xargs -0 rm -rf
    find "$@" -type f -name '.hg*' -print0 | xargs -0 rm -rf
}

# @FUNCTION: sage_clean_targets
# @USAGE: [list of makefile targets to clean]
# @DESCRIPTION:
# This function clears the prerequisites and commands for the specified targets
# in Sage's deps-makefile. If one wants to use e.g. sqlite from portage, do the
# following:
#
# @CODE
# sage_clean_targets SQLITE
# @CODE
#
# This modifies ${S}/spkg/standard/deps, which contains in sage-4.2.1 the
# following lines:
#
# @CODE
# $(INST)/$(SQLITE): $(INST)/$(TERMCAP) $(INST)/$(READLINE)
#     $(SAGE_SPKG) $(SQLITE) 2>&1
# @CODE
#
# The lines above will now be replaced with:
#
# @CODE
# $(INST)/$(SQLITE):
#     @echo "using SQLITE from portage"
# @CODE
#
# so that ${S}/spkg/standard/deps is still a valid makefile but without building
# sqlite.
sage_clean_targets() {
	for i in "$@"; do
		sed -i -n "
		# look for the makefile-target we need
		/^\\\$(INST)\/\\\$($i)\:.*/ {
			# clear the target's prerequisites and add a simple 'echo'-command
			# that will inform us that this target will not be built
			s//\\\$(INST)\/\\\$($i)\:\n\t@echo \"using $i from portage\"/p
			: label
			# go to the next line without printing the buffer (note that sed is
			# invoked with '-n') ...
			n
			# and check if its empty - if that is the case the target definition
			# is finished.
			/^\$/ {
				# print empty line ...
				p
				# and exit
				b
			}
			# this is not an empty line, so it must be a line containing
			# commands. Since we do not want these to be executed, we simply do
			# not print them and proceed with the next line
			b label
		}
		# default action: print line
		p
		" "${S}"/spkg/standard/deps
	done
}

# @FUNCTION: sage_package
# @USAGE: <spkg name> <commands>
# @DESCRIPTION:
# Extracts package and runs supplied command(s).
sage_package() {
	# change to Sage's standard spkg directory
	cd "${S}"/spkg/standard

	# make sure spkg is unpacked
	if [[ ! -d "$1" ]] ; then
		ebegin "Unpacking $1"
		tar -xf "$1.spkg" || die "tar failed"
		eend

		# remove the spkg file
		rm "$1.spkg" || die "rm failed"

		# record unpacked spkg
		_SAGE_UNPACKED_SPKGS=( ${_SAGE_UNPACKED_SPKGS[@]} $1 )
	fi

	# change to unpacked spkg directory
	cd "$1"

	local COMMAND=$2
	shift 2

	# execute commands
	"${COMMAND}" "$@" || die "${COMMAND} failed"
}

# @FUNCTION: sage_package_finish
# @USAGE:
# @DESCRIPTION:
# ATTENTION: This function must be executed if the sage_package-function was
# invoked. This cleans up and packs all unpacked spkgs.
sage_package_finish() {
	# change to Sage's standard spkg directory
	cd "${S}"/spkg/standard

	ebegin "Packing Sage packages"

	# pack all recorded packages
	for i in ${_SAGE_UNPACKED_SPKGS[@]} ; do
		tar -cf "$i.spkg" "$i" || die "tar failed"
		rm -rf "$i" || die "rm failed"
	done

	eend
}

# TODO: allow to switch between sage tarball and spkg uri

# @FUNCTION: sage_src_unpack
# @USAGE:
# @DESCRIPTION:
# If ${SAGE_PACKAGE} and ${SAGE_VERSION} is set this function is exported. It
# will unpack the specified spkgs and also correctly set the source directory
# ('${S}') and a variable ${SAGE_FILESDIR} which points to the patches
# directory, if available. Note that ${SAGE_PACKAGE} may be an array. If thats
# the case all spkgs contained will be unpacked.
sage_src_unpack() {
	cd "${WORKDIR}"

	# unpack all packages requested
	for i in "${SAGE_PACKAGE[@]}" ; do
		# unpack spkg-file from tar
		tar -xf "${DISTDIR}/${A}" --strip-components 3 \
			"sage-${SAGE_VERSION}/spkg/standard/$i.spkg" || die "tar failed"

		# unpack spkg-file
		tar -xjf "$i.spkg" || die "tar failed"

		# remove spkg-file
		rm "$i.spkg" || die "rm failed"
	done

	# if there is only one package, try to set SAGE_FILESDIR
	if [[ ${#SAGE_PACKAGE[@]} = 1 ]]; then
		# set Sage's FILESDIR
		if [[ -d "${WORKDIR}"/${SAGE_PACKAGE}/patches ]]; then
			SAGE_FILESDIR="${WORKDIR}"/${SAGE_PACKAGE}/patches
		elif [[ -d "${WORKDIR}"/${SAGE_PACKAGE}/patch ]]; then
			SAGE_FILESDIR="${WORKDIR}"/${SAGE_PACKAGE}/patch
		fi

		# if S is already set, do not change it
		if [[ "${S}" = "${WORKDIR}"/${P} ]]; then
			# if a src subdirectory exists point S to it
			if [[ -d "${WORKDIR}"/${SAGE_PACKAGE}/src ]]; then
				S="${WORKDIR}"/${SAGE_PACKAGE}/src
			else
				S="${WORKDIR}"/${SAGE_PACKAGE}
			fi
		fi
	else
		# if S is already set, do not change it
		if [[ "${S}" = "${WORKDIR}"/${P} ]]; then
			S="${WORKDIR}"
		fi
	fi
}

if [[ -n "${SAGE_PACKAGE}" ]]; then
	EXPORT_FUNCTIONS src_unpack
fi
