#!/bin/sh

# the awk script is taken from app-portage/eclass-manpages-20091209
awk -f eclass-to-manpage.awk ../eclass/sage.eclass > sage.eclass.5
