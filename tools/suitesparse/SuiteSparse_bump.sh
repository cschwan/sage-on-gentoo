#!/bin/bash
# two arguments
# - new version of SuiteSparse
# - path to the overlay containing suitesparse ebuilds

Sparse_PV=$1
Overlay_base=$2

# List of suitesparse packages - excluding SuiteSparse_config - as in upstream github repo
Sparse_PKG=(
        AMD
        BTF
        CAMD
        CCOLAMD
        CHOLMOD
        COLAMD
        CXSparse
        KLU
        LDL
        RBio
        SPEX
        SPQR
        UMFPACK
)

# creating a tmp folder
mkdir -p sparse_tmp
pushd sparse_tmp
# downloading and unfolding new suitesparse to get the various packages new version numbers
wget "https://github.com/drtimothyaldendavis/suitesparse/archive/refs/tags/v${Sparse_PV}.tar.gz"
tar xvfz "v${Sparse_PV}.tar.gz"
# save this path for later use when working out the versions
sparse_dir=`pwd`
popd

# Moving into the overlay
pushd "${Overlay_base}/sci-libs/" #into overlay

# versions
# Dealing with SuiteSparse_config first.
# Old version of SuiteSparse_config, new version is always the SuiteSparse version.
suitesparseconfig_old_v=$(find suitesparseconfig -name \*.ebuild | sed -e "s:suitesparseconfig/suitesparseconfig-::" -e "s:-r[0:9]::" -e "s:.ebuild::")
echo "suitesparseconfig from ${suitesparseconfig_old_v} to ${Sparse_PV}"
pushd suitesparseconfig # into suitesparseconfig
if [ ! -n "$DRYRUN" ]; then
        git mv suitesparseconfig-${suitesparseconfig_old_v}.ebuild suitesparseconfig-${Sparse_PV}.ebuild
        ebuild suitesparseconfig-${Sparse_PV}.ebuild manifest
else
        echo "the following would be executed"
        echo "git mv suitesparseconfig-${suitesparseconfig_old_v}.ebuild suitesparseconfig-${Sparse_PV}.ebuild"
        echo "ebuild suitesparseconfig-${Sparse_PV}.ebuild manifest"
fi
popd # out of suitesparseconfig

# version suffixes for packages' CMakeLists.txt files
SPLIT_V=(
        _VERSION_MAJOR
        _VERSION_MINOR
        _VERSION_SUB
)

for pkg in "${Sparse_PKG[@]}"; do
        # ebuild names ar all lower case
        pkg_name="${pkg,,}"
        # figuring the current version - including revision from ebuild name.
        # Note that it assumes there is only one ebuild per package.
        pkg_old_v=$(find ${pkg_name} -name \*.ebuild | sed -e "s:${pkg_name}/${pkg_name}-::" -e "s:.ebuild::")
        # figuring new version from downloaded tarball
        pkg_new_v=""
        # Path to CMakeLists.txt
        cmake_file="${sparse_dir}/SuiteSparse-${Sparse_PV}/${pkg}/CMakeLists.txt"
        for ver in "${SPLIT_V[@]}"; do
                # IN CMakeLists.txt, the packages name is in upper case.
                ver_num=$(awk -v the_pkg="${pkg^^}${ver}" '{ if ($3 == the_pkg) print $4}' "${cmake_file}")
                pkg_new_v="${pkg_new_v}.${ver_num}"
        done
        # Dropping the leading "." introduced in iteration
        pkg_new_v="${pkg_new_v:1}"
        echo "${pkg} from ${pkg_old_v} to ${pkg_new_v}"
        pushd "${pkg_name}" # into pkg_name
        if [ ! -n "$DRYRUN" ]; then
                git mv "${pkg_name}-${pkg_old_v}.ebuild" "${pkg_name}-${pkg_new_v}.ebuild"
                sed -e "s:Sparse_PV=\"[0-9].[0-9].[0-9]\":Sparse_PV=\"${Sparse_PV}\":" -i "${pkg_name}-${pkg_new_v}.ebuild"
                git add "${pkg_name}-${pkg_new_v}.ebuild"
                ebuild "${pkg_name}-${pkg_new_v}.ebuild" manifest
        else
                echo "the following would be executed"
                echo "git mv \"${pkg_name}-${pkg_old_v}.ebuild\" \"${pkg_name}-${pkg_new_v}.ebuild\""
                echo "sed -e \"s:Sparse_PV=\"[0-9].[0-9].[0-9]\":Sparse_PV=\"${Sparse_PV}\":\" -i \"${pkg_name}-${pkg_new_v}.ebuild\""
                echo "git add \"${pkg_name}-${pkg_new_v}.ebuild\""
                echo "ebuild \"${pkg_name}-${pkg_new_v}.ebuild\" manifest"
        fi
        popd # out of pkg_name
done

popd # out of overlay and back to execution folder

# clean up 
if [ -d sparse_tmp ]; then
        rm -rf sparse_tmp
else
        echo "could not find sparse_tmp to clean. Where I am?"
        pwd
fi
