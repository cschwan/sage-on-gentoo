#!/bin/bash
# two arguments
# - gentoo overlay path as the departure point
# - path to Gentoo tree fork as the destination

if [ $# -ne 2 ]; then
	echo "You need 2 arguments"
	echo "1) path to overlay containing the new ebuild"
        echo "2) path to to gentoo tree/fork to update"
	exit 1
fi

sog_overlay=$1
gentoo_dest=$2

# List of suitesparse ebuild
Sparse_ebuild=(
        amd
        btf
        camd
        ccolamd
        cholmod
        colamd
        cxsparse
        klu
        ldl
        rbio
        spex
        spqr
        suitesparseconfig
        umfpack
)

for pkg in "${Sparse_ebuild[@]}"; do
        echo "doing ${pkg}"
        # checking if pkg is in the gentoo tree. do not add if not.
        if [ -d "${gentoo_dest}/sci-libs/${pkg}/" ]; then
                rsync -rv --exclude=Manifest --exclude=metadata.xml "${sog_overlay}/sci-libs/${pkg}/" "${gentoo_dest}/sci-libs/${pkg}/"
                # update the manifest
                pushd "${gentoo_dest}/sci-libs/${pkg}/"
                ebuild *.ebuild manifest
                popd
        else
                echo "sci-libs/${pkg} doesn't exist in the main tree, It needs to be added separately as a new ebuild."
        fi
done

echo "all done"
