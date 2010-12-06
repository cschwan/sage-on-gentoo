PROJECT SUMMARY
===============

Sage-on-Gentoo provides split ebuilds (http://www.gentoo.org) for the computer
algebra system SAGE (http://www.sagemath.org).

If you have problems with sage-on-gentoo or have suggestions talk to us on
#gentoo-science on freenode:

  http://www.gentoo.org/main/en/irc.xml

or write a mail to the "gentoo-science" mailing list:

  http://www.gentoo.org/main/en/lists.xml

An archive listing past mails may be found at:

  http://archives.gentoo.org/gentoo-science/

QUICK INSTALLATION GUIDE
========================

1. *INSTALL AND CONFIGURE LAYMAN*:
   The preferred way of getting sage-on-gentoo is layman. Make sure layman is
   installed with USE=git and correctly configured. You may find a guide for
   layman at:

     http://www.gentoo.org/proj/en/overlays/userguide.xml

2. *ADD OUR OVERLAY*:
   Update your layman list and add this overlay with:

   ::

     layman -L
     layman -a sage-on-gentoo

3. *UNMASK AND USE-FLAG EBUILDS*:
   Before being able to install you will need to unmask the required ebuilds.
   You should use the following file which already contains all required
   entries:

   ::

     sage-on-gentoo/packages.keywords/sage

   For permanent unmasking place a symbolic link to that file into your
   /etc/portage/package.keywords/ directory:

   ::

     ln -s <path-to-layman>/sage-on-gentoo/package.keywords/sage \
           /etc/portage/package.keywords/sage

   Since Sage's ebuild requires its dependencies to be built with several USE-
   flags we provide a standard package.use file as well:

   ::

     ln -s <path-to-layman>/sage-on-gentoo/package.use/sage \
           /etc/portage/package.use/sage

   <path-to-layman> is usually /var/lib/layman (this path used to
   /usr/local/portage/layman for older version of layman).

4. *INSTALL SAGE*:
   Type

   ::

     emerge -va sage

   to install sage; please note that this will pull in a lot of dependencies.

5. *UPDATE YOUR LOCAL OVERLAY*:
   To update your local copy of sage-on-gentoo simply type:

   ::

     layman -S

   After that you may run

   ::

     emerge -vuDNa world

   or a similar command to check for updates.

INSTALLATION NOTES FOR GENTOO PREFIX
====================================

What is Gentoo Prefix? In one sentence, a Prefix enables you to install Gentoo
on different OS (e.g Linux, FreeBSD, MacOS, Solaris and even Windows). Thus, you
may be able to run Sage on Gentoo e.g. on a Debian Linux. For a complete
introduction into Gentoo Prefix and how to set it up go to

  http://www.gentoo.org/proj/en/gentoo-alt/prefix/

After having set up the Prefix you need additional dependencies which are not
yet in the prefixed portage:

  https://github.com/cschwan/sage-on-prefix

You need to manually clone the repository and to add the local copy to the

  ::

    PORTDIR_OVERLAY

variable in $EPREFIX/etc/make.conf. sage-on-prefix currently contains four
ebuilds which are hopefully being added to the main prefix tree soon.

If you have followed the previous steps you should be able to emerge sage as
described the quick installation guide (see above).

Currently we support every Linux running with x86 or amd64 instruction sets, in
particular the following architectures:

  - ~amd64-linux
  - ~x86-linux
