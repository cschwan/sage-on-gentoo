# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: sage-git-patch.eclass
# @MAINTAINER:
# François Bissey <frp.bissey@gmail.com>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Pull and apply PR from the sage repo as patch
# @DESCRIPTION:
# To avoid patch duplication with upstream, especially for supporting
# newer packages, it is useful to directly use git PR as patch.
# This eclass as a generic fetcher to add PR to SRC_URI and a special
# patch preparation process, as sage upstream PR patch are not directly
# applicable to produced sdist. This is because sdists have one less
# level depth compared to the git tree.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

BDEPEND="
	dev-util/patchutils
"

# @VARIABLE: GIT_PRS
# @REQUIRED
# @DESCRIPTION:
# An array of PR number from sagemath's git tree.
# It should be defined before inheriting the eclass.

# @FUNCTION: get_pr_uri
# @USAGE:
# @DESCRIPTION:
# generate the list of uri for the PR in GIT_PRS
get_pr_uri() {
	GIT_PR_URI=""
	for patch in "${GIT_PRS[@]}"; do
		GIT_PR_URI+=" https://github.com/sagemath/sage/pull/${patch}.patch -> sagemath_PR${patch}.patch"
	done
	echo "${GIT_PR_URI}"
}

SRC_URI+=$(get_pr_uri)

# @FUNCTION: sage-git-patch_patch
# @USAGE:
# @DESCRIPTION:
# Process the patches and apply them to the sdist.
# To be called src_prepare

sage-git-patch_patch() {
	if [ "${PN}" == "sage-doc" ]; then
		tree="doc"
	else
		tree="sage"
	fi
	for patch in "${GIT_PRS[@]}"; do
		# remove non-source files with patchutils
		filterdiff -i '*/src/${tree}/*' "${DISTDIR}/sagemath_PR${patch}.patch" > \
			"${DISTDIR}/${patch}_proc.patch" \
			|| die "patch for PR ${patch} not found"
		# apply with eapply
		eapply -p2 "${DISTDIR}/${patch}_proc.patch"
	done
}
