# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: sage-git.eclass
# @MAINTAINER:
# François Bissey <frp.bissey@gmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Create sdist froma git snapshot of sage
# @DESCRIPTION:
# sagemath packages are developed from a common git tree.
# It makes it hawkward when checking individual package.
# This eclass create appropriate package sdist from sage git snapshot.


case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: sage_git_to_sdist
# @USAGE: <optional sagemath package name>
# @DESCRIPTION:
# Create a sdist for the sagemath package passed as an argument or ${PN}
# if none passed. Proceed to unpack the sdist into ${S}

sage-git_src_unpack() {
	# If no value is passed, it default to ${PN}
	if [[ -z ${1} ]]; then
		my_pkg="${PN}"
	else
		my_pkg="${1}"
	fi

	# Checking the requested distribution exists
	[[ -d "${WORKDIR}/git_checkout/pkgs/${my_pkg}" ]] || die "${my_pkg} is not a valid sagemath subpackage"

	pushd "${WORKDIR}/git_checkout"
	einfo "Apply sdist patch if found"
	# This is to apply any patch that will change the sdist
	if [[ -e "${FILESDIR}/${my_pkg}-sdist.patch" ]]; then
		eapply "${FILESDIR}/${my_pkg}-sdist.patch"
	fi

	einfo "generating setup.cfg and al. - be patient"
	./bootstrap || die "boostrap failed"
	einfo "creating a ${my_pkg} sdist"
	python -m build -n -s \
		"pkgs/${my_pkg}" \
		--outdir "${WORKDIR}" || die "failed to create sdist"
	popd

	einfo "unpacking sdist to ${S}"
	pushd "${WORKDIR}"
	# "${S}" does not exist yet
	mkdir -p "${S}"
	# unpack
	tar --strip-components=1 -C "${S}" \
		-xvzf "${my_pkg}"-*.tar.gz || die "failed to unpack sdist"
	popd
}
