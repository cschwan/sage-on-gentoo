# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: scons-utils.eclass
# @MAINTAINER:
# gentoo@mgorny.alt.pl
# @BLURB: helper functions to deal with SCons buildsystem
# @DESCRIPTION:
# This eclass provides a set of function to help developers sanely call
# dev-util/scons and pass parameters to it.
# @EXAMPLE:
#
# @CODE
# inherit scons-utils
#
# src_compile() {
# 	escons \
# 		$(use_scons nls ENABLE_NLS) \
# 		|| die
# }
# @CODE

# -- public variables --

# @ECLASS-VARIABLE: SCONS_MIN_VERSION
# @DEFAULT_UNSET
# @DESCRIPTION:
# The minimal version of SCons required for the build to work.

# @ECLASS-VARIABLE: SCONSOPTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The default set of options to pass to scons. Similar to MAKEOPTS,
# supposed to be set in make.conf. If unset, escons() will use cleaned
# up MAKEOPTS instead.

# @ECLASS-VARIABLE: EXTRA_ESCONS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The additional parameters to pass to SCons whenever escons() is used.

# @ECLASS-VARIABLE: USE_SCONS_TRUE
# @DESCRIPTION:
# The default value for truth in scons-use() (1 by default).
: ${USE_SCONS_TRUE:=1}

# @ECLASS-VARIABLE: USE_SCONS_FALSE
# @DESCRIPTION:
# The default value for false in scons-use() (0 by default).
: ${USE_SCONS_FALSE:=0}

# -- ebuild variables setup --

if [[ -n ${SCONS_MIN_VERSION} ]]; then
	DEPEND=">=dev-util/scons-${SCONS_MIN_VERSION}"
else
	DEPEND="dev-util/scons"
fi

# -- public functions --

# @FUNCTION: escons
# @USAGE: [scons-arg] ...
# @DESCRIPTION:
# Call scons, passing the supplied arguments, ${MAKEOPTS} and
# ${EXTRA_ESCONS}. Similar to emake.
escons() {
	debug-print-function ${FUNCNAME} "${@}"

	# if SCONSOPTS are _unset_, use cleaned MAKEOPTS
	set -- scons ${SCONSOPTS-$(scons_clean_makeopts)} ${EXTRA_ESCONS} "${@}"
	echo "${@}" >&2
	"${@}"
}

# @FUNCTION: scons_clean_makeopts
# @USAGE: [makeflags] [...]
# @DESCRIPTION:
# Strip the supplied makeflags (or ${MAKEOPTS} if called without
# an argument) of options not supported by SCons and make sure --jobs
# gets an argument. Output the resulting flag list (suitable
# for an assignment to SCONSOPTS).
scons_clean_makeopts() {
	local new_makeopts

	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${#} -eq 0 ]]; then
		debug-print "Using MAKEOPTS: [${MAKEOPTS}]"
		set -- ${MAKEOPTS}
	else
		# unquote if necessary
		set -- ${*}
	fi

	# empty MAKEOPTS give out empty SCONSOPTS
	# thus, we do need to worry about the initial setup
	if [[ ${*} = ${_SCONS_CACHE_MAKEOPTS} ]]; then
		set -- ${_SCONS_CACHE_SCONSOPTS}
		debug-print "Cache hit: [${*}]"
		echo ${*}
		return
	fi
	export _SCONS_CACHE_MAKEOPTS=${*}

	while [[ ${#} -gt 0 ]]; do
		case ${1} in
			# clean, simple to check -- we like that
			--jobs=*|--keep-going)
				new_makeopts=${new_makeopts+${new_makeopts} }${1}
				;;
			# need to take a look at the next arg and guess
			--jobs)
				if [[ ${#} -gt 1 && ${2} =~ [0-9]+ ]]; then
					new_makeopts="${new_makeopts+${new_makeopts} }${1} ${2}"
					shift
				else
					# no value means no limit, let's pass a random int
					new_makeopts=${new_makeopts+${new_makeopts} }${1}=255
				fi
				;;
			# strip other long options
			--*)
				;;
			# short option hell
			-*)
				local str new_optstr
				new_optstr=
				str=${1#-}

				while [[ -n ${str} ]]; do
					case ${str} in
						k*)
							new_optstr=${new_optstr}k
							;;
						# -j needs to come last
						j)
							if [[ ${#} -gt 1 && ${2} =~ [0-9]+ ]]; then
								new_optstr="${new_optstr}j ${2}"
								shift
							else
								new_optstr="${new_optstr}j 255"
							fi
							;;
						# otherwise, everything after -j is treated as an arg
						j*)
							new_optstr=${new_optstr}${str}
							break
							;;
					esac
					str=${str#?}
				done

				if [[ -n ${new_optstr} ]]; then
					new_makeopts=${new_makeopts+${new_makeopts} }-${new_optstr}
				fi
				;;
		esac
		shift
	done

	set -- ${new_makeopts}
	export _SCONS_CACHE_SCONSOPTS=${*}
	debug-print "New SCONSOPTS: [${*}]"
	echo ${*}
}

# @FUNCTION: use_scons
# @USAGE: <use-flag> [var-name] [var-opt-true] [var-opt-false]
# @DESCRIPTION:
# Output an SCons parameter with value depending on the USE flag state.
# If the USE flag is set, output <var-name>=<var-opt-true>; otherwise
# <var-name>=<var-opt-false>.
#
# If <var-name> is not set, <use-flag> will be used instead.
# If <var-opt-true> or <var-opt-false> is unset, USE_SCONS_TRUE
# or USE_SCONS_FALSE will be used instead.
use_scons() {
	local flag=${1}
	local varname=${2:-${flag#!}}
	local vartrue=${3:-${USE_SCONS_TRUE}}
	local varfalse=${4:-${USE_SCONS_FALSE}}

	debug-print-function ${FUNCNAME} "${@}"

	if [[ ${#} -eq 0 ]]; then
		eerror "Usage: scons-use <use-flag> [var-name] [var-opt-true] [var-opt-false]"
		die 'scons-use(): not enough arguments'
	fi

	if use "${flag}"; then
		echo "${varname}=${vartrue}"
	else
		echo "${varname}=${varfalse}"
	fi
}

# -- self-tests --

_scons_clean_makeopts_perform_test() {
	local sconsopts=$(scons_clean_makeopts ${1})

	if [[ ${sconsopts} != ${2-${1}} ]]; then
		cat >&2 <<_EOF_
Self-test failed:
	Input string: ${1}
	Output string: ${sconsopts}
	Expected: ${2-${1}}
_EOF_
	fi
}

# Perform a self-test on scons-clean-makeopts.
_scons_clean_makeopts_tests() {
	# jobcount expected for non-specified state
	local jc=255

	# sane MAKEOPTS
	_scons_clean_makeopts_perform_test '--jobs=14 -k'
	_scons_clean_makeopts_perform_test '--jobs=14 -k'
	_scons_clean_makeopts_perform_test '--jobs 15 -k'
	_scons_clean_makeopts_perform_test '--jobs=16 --keep-going'
	_scons_clean_makeopts_perform_test '-j17 --keep-going'
	_scons_clean_makeopts_perform_test '-j 18 --keep-going'

	# needing cleaning
	_scons_clean_makeopts_perform_test '--jobs -k' "--jobs=${jc} -k"
	_scons_clean_makeopts_perform_test '--jobs --keep-going' "--jobs=${jc} --keep-going"
	_scons_clean_makeopts_perform_test '-kj' "-kj ${jc}"

	# broken by definition (but passed as it breaks make as well)
	_scons_clean_makeopts_perform_test '-jk'
	_scons_clean_makeopts_perform_test '--jobs=randum'
	_scons_clean_makeopts_perform_test '-kjrandum'

	# needing stripping
	_scons_clean_makeopts_perform_test '--load-average=25 -kj16' '-kj16'
	_scons_clean_makeopts_perform_test '--load-average 25 -k -j17' '-k -j17'
	_scons_clean_makeopts_perform_test '-j2 HOME=/tmp' '-j2'
	_scons_clean_makeopts_perform_test '--jobs funnystuff -k' "--jobs=${jc} -k"
}
