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
# Note that pkgcheck will complain that SRC_URI is unstable, which is
# a correct statement. PR added using this mechanism should be relatively "stable".
# Another limitation is that some PR with a long history may include incompatible
# commits In that case, using this eclass is not possible.

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
	# We need to filter the content of the PR.
	# we only care about content inside "src".
	# Furthermore the doc folder is not included in sdist and needs to be filtered out.
	# but it is the only thing we need when dealing with sage-doc.
	# The patch level is also not the same between sdist and sage-doc.
	if [ "${PN}" == "sage-doc" ]; then
		# for sage-doc we only care about src/doc
		tree="src/doc"
		# src is part of S in sage-doc
		plevel="-p1"
	else
		# for sdist we only care about src/sage
		tree="src/sage"
		# src is not part sage sdists we need to patch at the p2 level
		plevel="-p2"
	fi
	echo "Processing for ${tree}"
	for patch in "${GIT_PRS[@]}"; do
		# remove  files with patchutils
		filterdiff -i "*/${tree}/*" "${DISTDIR}/sagemath_PR${patch}.patch" > \
			"${T}/${patch}_proc.patch" \
			|| die "patch for PR ${patch} not found"
		eapply "${plevel}" "${T}/${patch}_proc.patch"
	done
}
