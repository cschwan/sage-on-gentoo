# HG changeset patch
# User Francois Bissey <francois.bissey@canterbury.ac.nz>
# Date 1365560553 -43200
# Node ID 420d6595dedf188431d282ec2057f49e42094563
# Parent  cca78f4051d111ca89ad3324c0823188b7681c3c
Fix non-library dependent problems with all.py

diff --git a/sage/all.py b/sage/all.py
--- a/sage/all.py
+++ b/sage/all.py
@@ -21,9 +21,9 @@
         sage: allowed = [os.path.join("lib","python","threading.py")]
         sage: allowed.append(os.path.join("lib","python","multiprocessing"))
         sage: allowed.append(os.path.join("sage","doctest"))
-        sage: allowed.append(os.path.join("local","bin","sage-runtests"))
+        sage: allowed.append(os.path.join("bin","sage-runtests"))
         sage: allowed.append(os.path.join("site-packages","IPython"))
-        sage: allowed.append(os.path.join("local","bin","sage-ipython"))
+        sage: allowed.append(os.path.join("bin","sage-ipython"))
         sage: allowed.append("<ipython console>")
         sage: allowed.append("<doctest sage.all[3]>")
         sage: allowed.append(os.path.join("sage","combinat","species","generating_series.py"))
@@ -294,36 +294,7 @@
 
 
 # Write a file indicating that Sage was started up successfully.
-# This is called by the sage-starts script.
-def _write_started_file():
-    """
-    Write a ``sage-started.txt`` file if it does not exist.  The
-    contents of this file do not matter, only its existence.
-    
-    The non-existence of this file will be used as a trigger to run
-    ``sage-starts`` during the Sage build.
-
-    TESTS:
-
-    Check that the file exists when Sage is running::
-
-        sage: started_file = os.path.join(SAGE_LOCAL, 'etc', 'sage-started.txt')
-        sage: os.path.isfile(started_file)
-        True
-    """
-    started_file = os.path.join(SAGE_LOCAL, 'etc', 'sage-started.txt')
-    # Do nothing if the file already exists
-    if os.path.isfile(started_file):
-        return
-
-    # Current time with a resolution of 1 second
-    import datetime
-    t = datetime.datetime.now().replace(microsecond=0)
-
-    O = open(started_file, 'w')
-    O.write("Sage %s was started at %s\n"%(sage.version.version, t))
-    O.close()
-
+# Don't do that on Gentoo.
 
 # Set a new random number seed as the very last thing
 # (so that printing initial_seed() and using that seed
