#!/bin/bash
# two arguments
# - gentoo overlay path as the departure point
# - path to Gentoo tree fork as the destination

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
        rsync -rv --exclude=Manifest --exclude=metadata.xml "${sog_overlay}/sci-libs/${pkg}/" "${gentoo_dest}/sci-libs/${pkg}/"
        pushd "${gentoo_dest}/sci-libs/${pkg}/"
        ebuild *.ebuild manifest
        popd
done
