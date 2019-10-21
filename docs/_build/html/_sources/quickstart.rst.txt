.. _quickstart:

============
Quickstart
============

This short How-To guides you from downloading ``obogaf::parser`` to make your first parsing with ``obogaf::parser``.

Installation
=====================

Please goto the :ref:`installation` section and chose one of the shown ways to install ``obogaf::parser`` (we suggest to use the :ref:`conda` option).

Load obogaf::parser library
==============================

To load ``obogaf::parser`` module, just type inside a Perl script ``use obogaf::parser``. More precisely, the *header* of your Perl script should be: 

.. code-block:: perl

    #!/usr/bin/perl

    use strict;
    use warnings;
    
    use obogaf::parser;

    ... beginning of your perl code ...

To run the Perl script you can make it executable by typing ``chmod +x perl-script.pl`` or by prefacing the script with the Perl interpreter (``perl perl-script.pl``).

Your first parsing 
==========================

Let us use ``obogaf::parser`` to extract edges (in the form ``source-destination``) from the Gene Ontology (GO) obo file. Firstly we must download the GO obo file from the `Gene Ontoloy website <http://geneontology.org/docs/download-ontology/>`_. Then we use ``obogaf-parser`` to extract edges.

.. code-block:: perl
    
    ## perl shebang (unix) 
    #!/usr/bin/perl  
    
    ## load the module
    use obogaf::parser;

    ## download GO obo file
    my $obofile= "gobasic.obo";
    my $gobo= qx{wget --output-document=$obofile http://purl.obolibrary.org/obo/go/go-basic.obo};
    print "GO obo file downloaded: done\n\n";

    ## extract and print GO edges
    my $gores= obogaf::parser::build_edges($obofile);
    print "${$gores}";

``obogaf::parser`` can do much more than that! Go to the :ref:`tutorial` section to discover what this module can do! But first get a look to :ref:`installation` section ... 
