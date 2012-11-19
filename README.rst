PROJECT SUMMARY
===============

Sage-on-Gentoo provides split ebuilds (http://www.gentoo.org) for the computer
algebra system SAGE (http://www.sagemath.org).

CONTACT
=======

If you have problems with sage-on-gentoo or have suggestions talk to us on
#gentoo-science on freenode

  http://www.gentoo.org/main/en/irc.xml

or write a mail to the "gentoo-science" mailing list

  http://www.gentoo.org/main/en/lists.xml

An archive listing past mails may be found at

  http://archives.gentoo.org/gentoo-science/

QUICK INSTALLATION GUIDE
========================

1. *INSTALL AND CONFIGURE LAYMAN*:
   The preferred way of getting sage-on-gentoo is layman. Make sure layman is
   installed with USE=git and correctly configured. You may find a guide for
   layman at:

     http://www.gentoo.org/proj/en/overlays/userguide.xml

2. *ADD OUR OVERLAY*:
   Update your layman list and add this overlay with::

     layman -L
     layman -a sage-on-gentoo

.. note:: Steps 3 and 4 may not be fully or at all necessary on your system. You
          might want to try skipping to step 5 first, and if it doesn't work,
          coming back and doing steps 3 and 4.

3. *UNMASK EBUILDS*:
   Before being able to install you may need to unmask the required ebuilds. If
   you are using Gentoo/unstable or Funtoo (i.e. you have a line like
   ``ACCEPT_KEYWORDS=~arch`` in your /etc/portage/make.conf) you can at least
   skip the ``keywords`` entries, but the ``unmask`` entries may still be
   relevant. You can make use of the following files, which already contain all
   required entries::

     sage-on-gentoo/package.unmask/sage
     sage-on-gentoo/package.keywords/sage

   To use these files permanently, place symbolic links to those files into your
   ``/etc/portage/package.unmask`` and ``/etc/portage/package.keywords/``
   directories, respectively::

     ln -s <path-to-layman>/sage-on-gentoo/package.unmask/sage \
           /etc/portage/package.unmask/sage
     ln -s <path-to-layman>/sage-on-gentoo/package.keywords/sage \
           /etc/portage/package.keywords/sage

   Otherwise, simply copy them into the respective directories for a one-time
   fix.

4. *ADD USE-FLAGS FOR EBUILDS*:
   Since Sage's ebuild requires its dependencies to be built with several USE-
   flags we provide a standard package.use file as well::

     ln -s <path-to-layman>/sage-on-gentoo/package.use/sage \
           /etc/portage/package.use/sage

   If you are using unstable or Funtoo you may also need the following file::

     ln -s <path-to-layman>/sage-on-gentoo/package.use/sage-unstable \
           /etc/portage/package.use/sage-unstable

   <path-to-layman> is usually /var/lib/layman (this path used to be
   /usr/local/portage/layman for older version of layman).

5. *INSTALL SAGE*:
   Type ::

     emerge -va sage

   to install sage; please note that this will pull in a lot of dependencies. If
   you can not proceed with this step (because of circular dependencies, missing
   USE-flags, and so on) please report this behavior.

   NOTE also, that we do _not_ recommend to use the ATLAS (sci-libs/blas-alas
   and/or sci-libs/lapack-atlas) blas/lapack implementation since we experienced
   some failures with it:

   - https://github.com/cschwan/sage-on-gentoo/issues/3
   - https://github.com/cschwan/sage-on-gentoo/issues/6

   However, this should not pose a problem since the default choice is the
   reference implementation.

6. *UPDATE YOUR LOCAL OVERLAY*:
   To update your local copy of sage-on-gentoo simply type::

     layman -S

   After that you may run ::

     emerge -vuDNa world

   or a similar command to check for updates.

SAGE ON GENTOO PREFIX
=====================

A Prefix enables you to install Gentoo on different OS (e.g Linux, FreeBSD,
MacOS, Solaris and even Windows). Thus, you may be able to run Sage on Gentoo
e.g. on a Debian Linux. For a complete introduction into Gentoo Prefix and how
to set it up visit

  http://www.gentoo.org/proj/en/gentoo-alt/prefix/

After having a working Prefix you may setup sage-on-gentoo in a Prefix by
following the quick installation guide.

Currently, we support every Linux running with x86 or amd64 instruction sets, in
particular the following architectures:

  - ~amd64-linux
  - ~x86-linux
