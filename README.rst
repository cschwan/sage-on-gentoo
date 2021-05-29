PROJECT SUMMARY
===============

Sage-on-Gentoo provides split ebuilds (http://www.gentoo.org) for the computer
algebra system SAGE (http://www.sagemath.org).

CONTACT
=======

If you have problems with sage-on-gentoo or have suggestions talk to us on
#gentoo-science 

https://www.gentoo.org/get-involved/irc-channels/

or write a mail to the "gentoo-science" mailing list

https://www.gentoo.org/get-involved/mailing-lists/all-lists.html

An archive listing past mails may be found at

http://archives.gentoo.org/gentoo-science/

QUICK INSTALLATION GUIDE
========================

Installation of the overlay
---------------------------

**Eselect-repository install**

The easiest way to enable the overlay is to::

    emerge --noreplace eselect-repository && eselect repository enable sage-on-gentoo && emerge --sync

and emerge the package as usual.

**Manual Install**

As per the current [Portage specifications](https://dev.gentoo.org/~zmedico/portage/doc/man/portage.5.html), ebuild repositories (a.k.a. overlays) can be managed via file collections under `/etc/portage/repos.conf/`, via the new [plug-in sync system](https://wiki.gentoo.org/wiki/Project:Portage/Sync).

To enable the overlay without the need for additional software, you first need to have `git` installed::

    emerge --ask --verbose dev-vcs/git

Then you need to add the science repository configuration by downloading the [sage-on-gentoo.conf](metadata/sage-on-gentoo.conf) file::

    wget https://raw.githubusercontent.com/cschwan/sage-on-gentoo/master/metadata/sage-on-gentoo.conf \
	    -O /etc/portage/repos.conf/sage-on-gentoo


**Manual Uninstall**

To uninstall the overlay, simply run::

    rm /etc/portage/repos.conf/sage-on-gentoo
    rm /var/db/repos/sage-on-gentoo -rf


USING the overlay to install sage(math)
=======================================

UNMASK EBUILDS
--------------

Before being able to install you may need to unmask the required ebuilds. If
you are using Gentoo/unstable or Funtoo (i.e. you have a line like
``ACCEPT_KEYWORDS=~arch`` in your /etc/portage/make.conf) you can at least
skip the ``keywords`` entries, but the ``unmask`` entries may still be
relevant. You can make use of the following files, which already contain all
required entries::

     sage-on-gentoo/package.unmask/sage
     sage-on-gentoo/package.keywords/sage
     sage-on-gentoo/package.keywords/sage.prefix (for prefix users only)

To use these files permanently, place symbolic links to those files into your
``/etc/portage/package.unmask`` and ``/etc/portage/package.keywords/``
directories, respectively (prefix users should adjust with their prefix)::

     ln -s /var/db/repos/sage-on-gentoo/package.unmask/sage \
           /etc/portage/package.unmask/sage
     ln -s /var/db/repos/sage-on-gentoo/package.keywords/sage \
           /etc/portage/package.keywords/sage

Otherwise, simply copy them into the respective directories for a one-time fix.

The sage.prefix files contains keywords for ebuilds lacking any prefix keywords.

ADD USE-FLAGS FOR EBUILDS
-------------------------

Since Sage's ebuild requires its dependencies to be built with several USE-flags 
we provide a standard package.use file as well::

     ln -s /var/db/repos/sage-on-gentoo/package.use/sage \
           /etc/portage/package.use/sage

You should also consider linking in the same way the file ``99sage-doc-bin``.
This file sets sane default options for installing html documentation from a binary
tarball. Building the sage documentation from scratch is memory hungry and you
shouldn't consider doing it with less than 6GB of free memory on your system.
This is only available for stable realease of sage (sage-X.Y). User of the development
version of sage (sage-9999 ebuild) need to build their own documentation from scratch
if they need it.

INSTALL SAGE
------------

Type::

     emerge -va sage

to install sage; please note that this will pull in a lot of dependencies. If
you can not proceed with this step (because of circular dependencies, missing
USE-flags, and so on) please report this behavior.

SAGE ON GENTOO PREFIX
=====================

A Prefix enables you to install Gentoo on different OS (e.g Linux, FreeBSD,
MacOS, Solaris and even Windows). Thus, you may be able to run Sage on Gentoo
e.g. on a Debian Linux. For a complete introduction into Gentoo Prefix and how
to set it up visit

http://www.gentoo.org/proj/en/gentoo-alt/prefix/

After having a working Prefix you may setup sage-on-gentoo in a Prefix by
following the quick installation guide.

Currently, we support every Linux running with amd64 instruction sets, in
particular the following architectures:

- ~amd64-linux
