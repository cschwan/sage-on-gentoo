# Copyright 1999-2009 Gentoo Foundation
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
SRC_URI="http://mirror.switch.ch/mirror/sagemath/src/sage-${SAGE_VERSION}.tar"

RESTRICT="mirror"

_SAGE_UNPACKED_SPKGS=( )

_sage_package_unpack() {
	# change to Sage's standard spkg directory
	cd "${S}"/spkg/standard

	# make sure spkg is unpacked
	if [[ ! -d "$1" ]] ; then
		ebegin "Unpacking $1"
		tar -xf "$1.spkg"
		eend

		# remove the spkg file
		rm "$1.spkg"

		# record unpacked spkg
		_SAGE_UNPACKED_SPKGS=( ${_SAGE_UNPACKED_SPKGS[@]} $1 )
	fi
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

# @FUNCTION: sage_package_patch
# @USAGE: <spkg name> <patch name>
# @DESCRIPTION:
# Executes 'epatch' inside the contents of a *.spkg-file. The spkg name must be
# given without the trailing ".spkg".
sage_package_patch() {
	_sage_package_unpack "$1"

	# change to the spkg's directory, apply patch and move back
	cd "$1"
	epatch "$2"
	cd ..
}

# @FUNCTION: sage_package_sed
# @USAGE: <spkg name> <arguments for sed>
# @DESCRIPTION:
# Executes 'sed' inside the contents of a *.spkg-file. The spkg name must be
# given without the trailing ".spkg".
sage_package_sed() {
	_sage_package_unpack "$1"

	cd "$1"
	shift 1
	sed "$@" || die "sed failed"
	cd ..
}

# @FUNCTION: sage_package_cp
# @USAGE: <spkg name> <arguments for cp>
# @DESCRIPTION:
# Executes 'cp' inside the contents of a *.spkg-file. The spkg name must be
# given without the trailing ".spkg".
sage_package_cp() {
	_sage_package_unpack "$1"

	cd "$1"
	shift 1
	cp "$@" || die "cp failed"
	cd ..
}

# TODO: Remove it
sage_package_nested_sed() {
	_sage_package_unpack "$1"

	cd "$1"
	tar -xf "$2.spkg" || die "tar failed"
	rm "$2.spkg" || die "rm failed"
	cd "$2"
	SPKG="$2"
	shift 2
	sed "$@" || die "sed failed"
	cd ..
	tar -cf "${SPKG}.spkg" "${SPKG}"
	rm -rf "${SPKG}"
	cd ..
}

# TODO: Remove it
sage_package_nested_patch() {
	_sage_package_unpack "$1"

	cd "$1"
	tar -xf "$2.spkg" || die "tar failed"
	rm "$2.spkg" || die "rm failed"
	cd "$2"
	epatch "$3"
	cd ..
	tar -cf "$2.spkg" "$2" || die "tar failed"
	rm -rf "$2"
	cd ..
}

# @FUNCTION: sage_package_finish
# @USAGE:
# @DESCRIPTION:
# ATTENTION: This function must be executed if one of the
# sage_package_*-functions was called. This cleans up and packs all unpacked
# spkgs.
sage_package_finish() {
	ebegin "Packing Sage packages"
	for i in ${_SAGE_UNPACKED_SPKGS[@]} ; do
		tar -cf "$i.spkg" "$i"
		rm -rf "$i"
	done
	eend
}

# @FUNCTION: sage_src_unpack
# @USAGE:
# @DESCRIPTION:
# If SAGE_PACKAGE and SAGE_VERSION is set this function is exported. It will
# unpack the specified spkg and also correctly set the source directory ('S')
# and a variable SAGE_FILESDIR which points to the patches directory, if
# available.
sage_src_unpack() {
	cd "${WORKDIR}"

	# unpack spkg-file from tar
	tar -xf "${DISTDIR}/${A}" --strip-components 3 \
		"sage-${SAGE_VERSION}/spkg/standard/${SAGE_PACKAGE}.spkg"

	# unpack spkg-file
	tar -xjf "${SAGE_PACKAGE}.spkg"

	# remove spkg-file
	rm "${SAGE_PACKAGE}.spkg"

	# set Sage's FILESDIR
	if [[ -d "${WORKDIR}/${SAGE_PACKAGE}/patches" ]]; then
		SAGE_FILESDIR="${WORKDIR}/${SAGE_PACKAGE}/patches"
	elif [[ -d "${WORKDIR}/${SAGE_PACKAGE}/patch" ]]; then
		SAGE_FILESDIR="${WORKDIR}/${SAGE_PACKAGE}/patch"
	fi

	# set correct source path
	if [[ -d "${WORKDIR}/${SAGE_PACKAGE}/src" ]]; then
		S="${WORKDIR}/${SAGE_PACKAGE}/src"
	fi
}

if [[ -n "${SAGE_PACKAGE}" ]]; then
	S="${WORKDIR}/${SAGE_PACKAGE}"

	EXPORT_FUNCTIONS src_unpack
fi
