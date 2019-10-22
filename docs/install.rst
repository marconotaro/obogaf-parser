.. _installation:

============
Installation
============

``obogaf::parser`` is available on CPAN as well as through Bioconda and also from source code. You can use one of the following ways for installing ``obogaf::parser``.

.. _conda:

Installation via Conda
========================

.. note::

  This is the recommended way of installing for normal users.

This is the recommended way to install ``obogaf::parser`` because it will enables you to switch software versions easily. And in addition Perl with all needed dependencies will be installed.

First, you have to install the Miniconda Python3 distribution. See `here <https://conda.io/docs/install/quick.html>`_ for installation instructions. Make sure to ...

 - Install the *Python 3* version of Miniconda.
 - Answer yes to the question whether conda shall be put into your PATH.

Then, you can install ``obogaf::parser`` with

.. code-block:: console

  TODO 

from the `Bioconda <https://bioconda.github.io>`_ channel.

Global Installation
========================

You can directly install the module via ``cpan``:

.. code-block:: console

  $ cpan install obogaf::parser

or via ``cpanm``:

.. code-block:: console

  $ cpanm obogaf::parser

make sure to install ``cpanm`` before running the command above

.. note::
  
  to install the ``obogaf::parser`` globally you must be a root-user

Local Installation
========================

If you do not have root permit, you can clone (or download) the ``obogaf::parser`` git repository (`link <https://github.com/marconotaro/obogaf-parser.git>`_) and initialize your Perl script as follow:

.. code-block:: perl

 #!/usr/bin/perl 

 use strict;
 use warnings;
 use lib 'path/to/folder/containing/obogaf-parser-module'; ## nb: folder != full filename
 use parser;

 ... beginning of your Perl code ...

.. _install_from_source:

Installing from Source
=======================

To build ``obogaf::parser`` from scratch follow the command shown below:

.. code-block:: bash

  $ cd ~;
  $ git clone git://github.com/marconotaro/obogaf-parser.git obogaf-parser;
  $ cd obogaf-parser;

  $ perl Makefile.PL;
  $ make manifest;
  $ make;
  $ make test;
  $ sudo make install;
  $ make veryclean; ## to clean built files

Dependencies
==============

For building ``obogaf::parser`` you will need the following dependencies

 - Perl (v 5.22.1)
 - Perl-module:
    - Graph - graph data structures and algorithms

    
    
    



