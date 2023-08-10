# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: sage-git.eclass
# @MAINTAINER:
# François Bissey <frp.bissey@gmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Create sdist from a git snapshot of sage
# @DESCRIPTION:
# sagemath packages are developed from a common git tree.
# It makes it hawkward when checking individual packages.
# This eclass helps creating appropriate package sdist 
# from a sage git snapshot and then properly unpacking them in S.

inherit git-r3 python-r1

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

BDEPEND="
	sys-devel/autoconf
	dev-python/build[${PYTHON_USEDEP}]
"

# Standard variables for ebuild using sage-git
# @VARIABLE: EGIT_CHECKOUT_DIR
# @REQUIRED
# @DESCRIPTION:
# This variable is from the git-r3 eclass, we set it to a meaningful default
# for this eclass. It can still be overriden but should not be set to S
if [[ -z ${EGIT_CHECKOUT_DIR} ]]; then
	EGIT_CHECKOUT_DIR="${WORKDIR}/git_checkout"
elif [[ "${EGIT_CHECKOUT_DIR}" == "${S}" ]]; then
	die "EGIT_CHECKOUT_DIR and S are the same (${EGIT_CHECKOUT_DIR} and ${S}) which is not supported"
fi
KEYWORDS=""

# @FUNCTION: sage-git_src_unpack
# @USAGE:
# @DESCRIPTION:
# Standard unpacking of a sage git checkout and other associated
# distribution files. Create S so that src_prepare phase can find it.

sage-git_src_unpack() {
	git-r3_src_unpack
	
	mkdir -p "${S}"
	
	default
}

# @FUNCTION: sage-git_src_prepare
# @USAGE: <optional sagemath package name>
# @DESCRIPTION:
# Create a sdist from the git checkout for the sagemath package
# passed as an argument or ${PN} if none passed.
# Proceed to unpack the sdist into ${S}
# If the git checkout needs to be patched before producing a working
# sdist, this can be done if there is a patch named:
# pkg_name-sdist.patch
# in FILESDIR

sage-git_src_prepare() {
	# If no value is passed, it default to ${PN}
	if [[ -z ${1} ]]; then
		my_pkg="${PN}"
	else
		my_pkg="${1}"
	fi

	# Checking the requested distribution exists
	[[ -d "${EGIT_CHECKOUT_DIR}/pkgs/${my_pkg}" ]] || die "${my_pkg} is not a valid sagemath subpackage"

	pushd "${EGIT_CHECKOUT_DIR}"
	einfo "Apply sdist patch if found"
	# This is to apply any patch that will change the sdist
	if [[ -e "${FILESDIR}/${my_pkg}-sdist.patch" ]]; then
		eapply "${FILESDIR}/${my_pkg}-sdist.patch"
	fi

	einfo "generating setup.cfg and al. - be patient"
	./bootstrap || die "boostrap failed"
	einfo "creating a ${my_pkg} sdist"
	# calling python_setup to set PYTHON/EPYTHON
	python_setup
	${EPYTHON} -m build -n -x -s \
		"pkgs/${my_pkg}" \
		--outdir "${WORKDIR}" || die "failed to create sdist"
	popd

	einfo "unpacking sdist to ${S}"
	pushd "${WORKDIR}"
	# unpack
	# Note that we catch the special case sage-conf/sage-conf_pypi here.
	tar --strip-components=1 -C "${S}" \
		-xvzf "${my_pkg%_pypi}"-*.tar.gz || die "failed to unpack sdist"
	popd
}

EXPORT_FUNCTIONS src_unpack
