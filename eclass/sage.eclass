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
# @BLURB: Variables storing Sage's installation path
# @DESCRIPTION:
# The Sage eclass contains variables which store installation paths of Sage's
# components

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
