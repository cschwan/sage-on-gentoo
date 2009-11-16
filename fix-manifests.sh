#!/bin/sh

WORKING_DIR="$(pwd)"

for i in $(find . -name *.ebuild); do
	cd $(dirname $(readlink -f $i))
	ebuild $(basename $i) manifest
	cd "${WORKING_DIR}"
done
