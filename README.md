JHBuild modulesets for LIGO and open-source astronomy software
==============================================================

This is a collection of JHBuild (<https://live.gnome.org/Jhbuild>)
modules for LIGO Parameter Estimation (LALInference).

It is a fork of Leo Singer's (<https://github.com/lpsinger/modulesets>) personal
collection of JHBuild modules for automating build and installation of
bleeding-edge packages for LIGO data analysis and open source astronomy.

As a taste, installing all of lalsuite and the attendant Python packages
one-by-one becomes just:

    $ jhbuild build lalsuite

Or, if you'd rather see a progress bar instead of all of the build output,
you can add the `-q` flag:

    $ jhbuild build -q lalsuite

And entering the preconfigured shell with `PATH`, `PKG_CONFIG_PATH`,
`PYTHONPATH`, etc. preconfigured is just:

    $ jhbuild shell


Instructions
------------

The `install_lalinference_cbc.sh` script contains all the commands for a standard
installation on the LIGO Data Grid and can be run as is:

    $ nohup ./install_lalinference_cbc.sh &

The codes will be installed in `~/pe` and published in `~/public_html/pe/build`
to be viewable on the web.

Manual Installation
-------------------

To use, first clone this repository into your home directory under
`~/modulesets` as follows:

    $ git clone git://github.com/vivienr/modulesets.git ~/modulesets

Next, clone and install JHBuild as follows (adapted from
<http://developer.gnome.org/jhbuild/unstable/getting-started.html.en>):

    $ mkdir -p ~/src && git clone git://git.gnome.org/jhbuild ~/src/jhbuild
    $ cd ~/src/jhbuild
    $ ./autogen.sh
    $ make
    $ make install

Optionally, add the following line to your login script so that the `jhbuild`
command is in your `PATH`:

    export PATH=$PATH:~/.local/bin

Remember to log out and log back in for the new environment variable to take
effect. Next, symlink the bundled JHBuild configuration file to
`~/.config/jhbuildrc`:

    $ mkdir -p ~/.config && cd ~/.config && ln -s ~/modulesets/jhbuildrc

Finally, build `lalsuite` with:

    $ jhbuild build lalsuite

To start a shell with your newly built packages in the environment, run:

    $ jhbuild shell


Experimental Support for Intel C Compiler (ICC)
-----------------------------------------------

There is now experimental support for compiling the LIGO/Virgo software stack
(LALSuite) using the Intel C Compiler (`icc`), which is available on LIGO Data
Grid computing clusters. To enable building with `icc`, add the line
`icc = True` to your jhbuild configuration script as follows:

    $ echo 'icc = True' >> ~/.config/my.jhbuildrc


Change installation options (branch, compile flags, ...)
--------------------------------------------------------

Any file of the name *.jhbuildrc in the configuration directory will be picked
up by jhbuild and can be used to modify default settings. (See for an example the
pe.jhbuildrc file). To set a particular branch for a particular package, for instance
compiling the `lalsimulation package` from the branch `lalinference_o2`, use:

    $ echo "branches['lalsimulation'] = (None,'lalinference_o2')" >> ~/.config/my.jhbuildrc

To set specific compiler flag, such as debug options:

    $ echo "os.environ['CFLAGS'] = '-Wall -g -O0'" >> ~/.config/my.jhbuildrc

More details are available in the JHBuild manual (<https://developer.gnome.org/jhbuild/unstable/config-reference.html.en>)

MacPorts
--------

For building LALSuite on [MacPorts](https://www.macports.org), Leo suggests using
the GCC 6 compiler toolchain (instead of clang) for full OpenMP support. On Mac
OS, make sure that your MacPorts ports are up to date, and then run the
following commands:

    $ sudo port install openmpi-gcc6
    $ sudo port select --set gcc mp-gcc6
    $ sudo port select --set mpi openmpi-gcc6-fortran


Details
-------

- The `install_lalinference_cbc.sh` is run on the cbc account of most LDG
  clusters, and the results are viewable online, for instance
  [here](https://ldas-jobs.ligo.caltech.edu/~cbc/pe/build/).

- Source code for modules is checked out into `~/src` (or `~/pe/src` when using
  `install_lalinference_cbc.sh`).

- For packages that support building out-of-srcdir, the build directory is
  in `/usr1/$USER/build`, `/local/$USER/build`,
  `/localscratch/$USER/build` or `/var/tmp/$USER/build`, to
  accommodate scratch storage locations on LSC data analysis clusters.

- Packages are installed into `~/local` (or `~/pe/local` when using
  `install_lalinference_cbc.sh`).

- You will be reminded whenever you are inside the JHBuild environment shell
  by the colorized prompt beginning with the text `JHBuild:`.
