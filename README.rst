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
   Update your layman list:: 

     layman -L

   This overlay now depends on the science overlay. So you will need to add it as well
   if it is not already installed::

     layman -a science

   Finally add this overlay::

     layman -a sage-on-gentoo

.. note:: Steps 3 and 4 may not be fully or at all necessary on your system. You
          might want to try skipping to step 5 first, and if it doesn't work,
          coming back and doing steps 3 and 4.

3. *USE THE PROFILE*:
   This overlay provides three types of profiles::

     stable
     stable/bindoc
     devel

   you can see them with the command::

     eselect profile list

   the fastest method for using the profile chosen is via::

     eselect profile set <number>

   where <number> is the number of the profile you want to use.

   Alternatively, if you don't want to lose your profile, you can combine your
   existing profile with one of the sage-on-gentoo overlay; you may want to
   get a look to this link

   https://wiki.gentoo.org/wiki/Profile_(Portage)#Combining_profiles

   or follow our quickguide.
   To get started you need a local overlay, for example in::

     /usr/local/portage

   next you have to put this line::

     profile-formats = portage-2

   in the file::

     /usr/local/portage/metadata/layout.conf

   then you have to create the path for your local profile, for example combining
   hardened-amd64 with stable-bindoc-amd64::

     mkdir -p /usr/local/portage/profiles/hardened/linux/amd64/sage-stable-bindoc/

   once created, you put the lines corresponding to the path of the profiles (found
   with eselect profile list)

     sage-on-gentoo:default/linux/amd64/13.0/stable/bindoc
     gentoo:hardened/linux/amd64

   in::

     /usr/local/portage/profiles/hardened/linux/amd64/sage-stable-bindoc/parent

   remember that the order matters.
   Lastly you have to add a line corresponding to the path you have created
   following this format::

     amd64 hardened/linux/amd64/sage-stable-bindoc stable

   to the file::

     /usr/local/portage/profiles/profiles.desc

   remember to change "stable" into "dev" if you use the "devel" profile or into
   "exp" if you use any of the prefix profiles and "amd64" to your architecture.

   The new profile will show if you run::

     eselect profile list

   and now you can choose it with::

     eselect profile set <number>

5. *INSTALL SAGE*:
   Type::

     emerge -va sage

   to install sage; please note that this will pull in a lot of dependencies. If
   you can not proceed with this step (because of circular dependencies, missing
   USE-flags, and so on) please report this behavior.

6. *UPDATE YOUR LOCAL OVERLAY*:
   To update your local copy of sage-on-gentoo simply type::

     layman -S

   Do not forget to update the main portage tree as well::

     emerge --sync

   After that you may run::

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
