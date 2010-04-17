# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: sage.eclass
# @MAINTAINER:
# Francois Bissey <f.r.bissey@massey.ac.nz>
# Christopher Schwan <cschwan@students.uni-mainz.de>
#
# Original authors: Francois Bissey <f.r.bissey@massey.ac.nz>
#	Christopher Schwan <cschwan@students.uni-mainz.de>
# @BLURB: Tools to ease the compilation of Sage's spkg-packages and Sage itself
# @DESCRIPTION:
# The sage eclass eases the compilation of Sage itself by providing functions
# for patching and modifying its *.spkg-files and by providing variables
# pointing to the Sage installation directory which are used by the
# sci-mathematics/sage-XXX ebuilds.

inherit eutils

# @ECLASS-VARIABLE: SAGE_PREFIX
# @DESCRIPTION:
# Points to the directory where Sage will be installed
SAGE_PREFIX="/opt"

# @ECLASS-VARIABLE: SAGE_ROOT
# @DESCRIPTION:
# Points to the directory where Sage's files will be placed
SAGE_ROOT="${SAGE_PREFIX}/sage"

# @ECLASS-VARIABLE: SAGE_DATA
# @DESCRIPTION:
# Points to the directory where Sage's data files will be installed to
SAGE_DATA="${SAGE_ROOT}/data"

# @ECLASS-VARIABLE: SAGE_LOCAL
# @DESCRIPTION:
# Points to the directory where Sage's local directory will be
SAGE_LOCAL="${SAGE_ROOT}/local"

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
