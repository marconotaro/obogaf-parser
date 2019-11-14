.. _tutorial:

Tutorial
========

Here we show a step-by-step application of ``obogaf::parser`` by using the Gene Ontology (``GO``) and the Human Phenotype Ontology (``HPO``) and their respective annotation file. The snippets of Perl code shown in the examples below are glued together respectively in the script ``GOscript.pl`` and ``HPOscript.pl`` stored in ``script`` folder of the github repository (`link <https://github.com/marconotaro/obogaf-parser/tree/master/script/>`__).

----

The experiments run on this tutorial were executed by using the ``obogaf::parser`` version ``1.27``, the Perl version ``5.22.1`` and on a machine having Ubuntu 16.04 as operative system.

----

Application to the Gene Ontology (GO)
-------------------------------------

For all the examples shown in this tutorial, we store I/O files in the directory ``example/data``: 

.. code-block:: bash

   $ cd ~ && mkdir -p example/data  ## create a directory if it does not already exist

Parse the GO obo file
~~~~~~~~~~~~~~~~~~~~~

First of all we must download the *obo* file from the `Gene Ontoloy website <http://geneontology.org/docs/download-ontology/>`_. We download the *basic* version of the **GO**, because this version excludes relationships that cross the 3 **GO** hierarchies (``BP``, ``MF``, ``CC``). To do that in a Linux environment, just type on the bash:

.. code-block:: bash

   $ cd example/data && wget http://purl.obolibrary.org/obo/go/go-basic.obo -O gobasic.obo

Let's have a look to the ``gobasic.obo`` (release ``2019-10-07``) file to see how it is structured. For instance, to display the first ``60`` lines we can type on the Linux Shell ``head -n60 example/data/gobasic.obo``:

.. code-block:: text

   format-version: 1.2
   data-version: releases/2019-10-07
   subsetdef: gocheck_do_not_annotate "Term not to be used for direct annotation"
   subsetdef: gocheck_do_not_manually_annotate "Term not to be used for direct manual annotation"
   subsetdef: goslim_agr "AGR slim"
   subsetdef: goslim_aspergillus "Aspergillus GO slim"
   subsetdef: goslim_candida "Candida GO slim"
   subsetdef: goslim_chembl "ChEMBL protein targets summary"
   subsetdef: goslim_flybase_ribbon "FlyBase Drosophila GO ribbon slim"
   subsetdef: goslim_generic "Generic GO slim"
   subsetdef: goslim_metagenomics "Metagenomics GO slim"
   subsetdef: goslim_mouse "Mouse GO slim"
   subsetdef: goslim_pir "PIR GO slim"
   subsetdef: goslim_plant "Plant GO slim"
   subsetdef: goslim_pombe "Fission yeast GO slim"
   subsetdef: goslim_synapse "synapse GO slim"
   subsetdef: goslim_yeast "Yeast GO slim"
   synonymtypedef: syngo_official_label "label approved by the SynGO project"
   synonymtypedef: systematic_synonym "Systematic synonym" EXACT
   default-namespace: gene_ontology
   remark: cvs version: use data-version
   remark: Includes Ontology(OntologyID(OntologyIRI(<http://purl.obolibrary.org/obo/go/never_in_taxon.owl>))) [Axioms: 18 Logical Axioms: 0]
   ontology: go

   [Term]
   id: GO:0000001
   name: mitochondrion inheritance
   namespace: biological_process
   def: "The distribution of mitochondria, including the mitochondrial genome, into daughter cells after mitosis or meiosis, mediated by interactions between mitochondria and the cytoskeleton." [GOC:mcc, PMID:10873824, PMID:11389764]
   synonym: "mitochondrial inheritance" EXACT []
   is_a: GO:0048308 ! organelle inheritance
   is_a: GO:0048311 ! mitochondrion distribution

   [Term]
   id: GO:0000002
   name: mitochondrial genome maintenance
   namespace: biological_process
   def: "The maintenance of the structure and integrity of the mitochondrial genome; includes replication and segregation of the mitochondrial chromosome." [GOC:ai, GOC:vw]
   is_a: GO:0007005 ! mitochondrion organization

   [Term]
   id: GO:0000003
   name: reproduction
   namespace: biological_process
   alt_id: GO:0019952
   alt_id: GO:0050876
   def: "The production of new individuals that contain some portion of genetic material inherited from one or more parent organisms." [GOC:go_curators, GOC:isa_complete, GOC:jl, ISBN:0198506732]
   subset: goslim_agr
   subset: goslim_chembl
   subset: goslim_flybase_ribbon
   subset: goslim_generic
   subset: goslim_pir
   subset: goslim_plant
   synonym: "reproductive physiological process" EXACT []
   xref: Wikipedia:Reproduction
   is_a: GO:0008150 ! biological_process

   [Term]
   id: GO:0000005
   name: obsolete ribosomal chaperone activity

   ... to be continued ...

To extrapolate the **GO** edges from the ``gobasic.obo`` file, we can use the subroutine ``build_edges``. This subroutine receives in input the ``obo`` file:

.. code-block:: perl

   ## loading the obo file and calling the subroutine
   my $obofile= "example/data/gobasic.obo";
   my $gores= obogaf::parser::build_edges($obofile);

   ## storing
   my $goedges= "example/data/gobasic-edges.txt";
   open OUT, "> $goedges"; 
   print OUT "${$gores}"; ## dereferencing
   close OUT;

For the sake of the space, below we just show the first ``25`` lines of the output file ``gobasic-edges.txt`` (``head -n25 example/data/gobasic-edges.txt``): 

.. code-block:: text

   biological_process   GO:0048308  GO:0000001  organelle inheritance   mitochondrion inheritance  is-a
   biological_process   GO:0048311  GO:0000001  mitochondrion distribution mitochondrion inheritance  is-a
   biological_process   GO:0007005  GO:0000002  mitochondrion organization mitochondrial genome maintenance is-a
   biological_process   GO:0008150  GO:0000003  biological_process   reproduction   is-a
   molecular_function   GO:0005385  GO:0000006  zinc ion transmembrane transporter activity  high-affinity zinc transmembrane transporter activity is-a
   molecular_function   GO:0005385  GO:0000007  zinc ion transmembrane transporter activity  low-affinity zinc ion transmembrane transporter activity is-a
   molecular_function   GO:0000030  GO:0000009  mannosyltransferase activity  alpha-1,6-mannosyltransferase activity is-a
   molecular_function   GO:0016765  GO:0000010  transferase activity, transferring alkyl or aryl (other than methyl) groups   trans-hexaprenyltranstransferase activity is-a
   biological_process   GO:0007033  GO:0000011  vacuole organization vacuole inheritance  is-a
   biological_process   GO:0048308  GO:0000011  organelle inheritance   vacuole inheritance  is-a
   biological_process   GO:0006281  GO:0000012  DNA repair  single strand break repair is-a
   molecular_function   GO:0004520  GO:0000014  endodeoxyribonuclease activity   single-stranded DNA endodeoxyribonuclease activity is-a
   cellular_component   GO:1902494  GO:0000015  catalytic complex phosphopyruvate hydratase complex   is-a
   cellular_component   GO:0005829  GO:0000015  cytosol  phosphopyruvate hydratase complex   part-of
   molecular_function   GO:0004553  GO:0000016  hydrolase activity, hydrolyzing O-glycosyl compounds  lactase activity  is-a
   biological_process   GO:0042946  GO:0000017  glucoside transport  alpha-glucoside transport  is-a
   biological_process   GO:0051052  GO:0000018  regulation of DNA metabolic process regulation of DNA recombination  is-a
   biological_process   GO:0000018  GO:0000019  regulation of DNA recombination  regulation of mitotic recombination is-a
   biological_process   GO:0051231  GO:0000022  spindle elongation   mitotic spindle elongation is-a
   biological_process   GO:1903047  GO:0000022  mitotic cell cycle process mitotic spindle elongation is-a
   biological_process   GO:0000070  GO:0000022  mitotic sister chromatid segregation   mitotic spindle elongation part-of
   biological_process   GO:0007052  GO:0000022  mitotic spindle organization  mitotic spindle elongation part-of
   biological_process   GO:0005984  GO:0000023  disaccharide metabolic process   maltose metabolic process  is-a
   biological_process   GO:0000023  GO:0000024  maltose metabolic process  maltose biosynthetic process  is-a
   biological_process   GO:0046351  GO:0000024  disaccharide biosynthetic process   maltose biosynthetic process  is-a

   ... to be continued ...

The first column of the output file refers to the domain whose a **GO** term belong to, the second and the third column represent the edge as pair of nodes in the form ``source (parent) - destination (child)``, the fourth and the fifth column are the name of the source and destination obo term ID and the sixth column refers to the kind of relationships. This column can assume only two values, ``is-a`` and ``part-of``, since it is safe grouping annotations by using both these relationships. For more details about **GO** relationships have a look at this `link <http://geneontology.org/docs/ontology-relations/>`__.

To isolate nodes and relationships belonging to one of the **GO** sub-ontology (e.g. ``biological_process (BP)``), we can use the subroutine ``build_subonto``. This subroutine receives in input the edges file obtained by calling ``build_edges`` and the specific sub-domain for which we want to extrapolate edges. 

.. code-block:: perl

   ## loading and calling
   my $goedges= "example/data/gobasic-edges.txt"; ## obtained previously by calling obogaf::parser::build_edges
   my $BPres= obogaf::parser::build_subonto($goedges, "biological_process");

   ## storing
   my $BPedges= "example/data/gobasic-edgesBP.txt";
   open OUT, "> $BPedges";
   print OUT "${$BPres}";
   close OUT;

Below we report the first ``10`` lines of ``gobasic-edgesBP.txt`` (``head -n10 example/data/gobasic-edgesBP.txt``):

.. code-block:: text

   GO:0048308  GO:0000001  organelle inheritance   mitochondrion inheritance  is-a
   GO:0048311  GO:0000001  mitochondrion distribution mitochondrion inheritance  is-a
   GO:0007005  GO:0000002  mitochondrion organization mitochondrial genome maintenance is-a
   GO:0008150  GO:0000003  biological_process   reproduction   is-a
   GO:0007033  GO:0000011  vacuole organization vacuole inheritance  is-a
   GO:0048308  GO:0000011  organelle inheritance   vacuole inheritance  is-a
   GO:0006281  GO:0000012  DNA repair  single strand break repair is-a
   GO:0042946  GO:0000017  glucoside transport  alpha-glucoside transport  is-a
   GO:0051052  GO:0000018  regulation of DNA metabolic process regulation of DNA recombination  is-a
   GO:0000018  GO:0000019  regulation of DNA recombination  regulation of mitotic recombination is-a

   ... to be continued ...

It is worth noting that the same output can be also achieved by using the ``grep`` command (in a Linux environment):

.. code-block:: bash

   $ grep "biological_process" example/data/gobasic-edges.txt | cut -f2- > example/data/gobasic-edgesBP.txt

If we want to isolate nodes and relationships separately for each **GO** subontology at one fell swoop, by Perl:

.. code-block:: perl

   my $goedges= "example/data/gobasic-edges.txt"; ## obtained previously by calling obogaf::parser::build_edges
   my @domains= qw(biological_process molecular_function cellular_component);
   my %aspects=(biological_process => "BP", molecular_function => "MF", cellular_component => "CC");

   foreach my $domain (@domains){
       my $outfile= "example/data/gobasic-edges"."$aspects{$domain}".".txt";
       open OUT, "> $outfile";
       my $domainres= obogaf::parser::build_subonto($goedges, $domain);
       print OUT "${$domainres}";
       close OUT;
   }

and by bash:

.. code-block:: bash

   goedges="example/data/gobasic-edges.txt"; ## obtained previously by calling obogaf::parser::build_edges
   domains=("biological_process" "molecular_function" "cellular_component");
   aspects=("BP" "MF" "CC");

   len="${#domains[@]}";
   for ((i = 0 ; i < len ; i++)); do
       grep ${domains[$i]} example/data/gobasic-edges.txt | cut -f2- > example/data/gobasic-edges${aspects[$i]}.txt
   done

To print some statistics on the ``GO`` graph, we can use the subroutine ``make_stat``. The input arguments required by this subroutine are:


#. ``$goedges``: file containing the ``GO`` graph represented as a list of edges where each edge is turn represented as a pair of vertices ``tab`` separated (``$goedges`` file can be obtained by calling the ``build_edges`` subroutine)
#. ``$parentIndex`` and ``$childIndex``: index referring restrictively to the column containing the ``source`` and ``destination`` nodes in the ``$goedges`` file (reminder: Perl starts counting from zero).

.. code-block:: perl

   my ($goedges, $parentIndex, $childIndex)= ("example/data/gobasic-edges.txt", 1, 2);
   my $res= obogaf::parser::make_stat($goedges, $parentIndex, $childIndex);
   print "$res";

   ## results printed on the shell
   #oboterm <tab> degree <tab> indegree <tab> outdegree
   GO:0032991  469   1  468
   GO:0110165  436   1  435
   GO:0016616  346   1  345
   GO:0016709  303   2  301
   GO:0016758  204   1  203
   GO:0048856  199   1  198
   GO:0098797  181   2  179
   GO:0003006  172   2  170
   GO:0005737  171   2  169
   GO:0016747  159   1  158
   .
   .
   .
   ~summary stat~
   nodes: 44733
   edges: 82705
   max degree: 469
   min degree: 1
   median degree: 2.0000
   average degree: 1.8489
   density: 4.1332e-05

As we can observe from the snippet above, for each node of the graph, ``degree``, ``in-degree`` and ``out-degree`` are printed. Nodes are sorted in a decreasing order on the basis of degree, from the higher to the smaller one. In addition the following statistics are also returned: 1) number of nodes and edges of the graph; 2) maximum and minimum degree; 3) average and median degree; 4) density of the graph. 

To compute the stats just for a specific ``GO`` subontology (e.g. ``GO BP``) we can always use ``make_stat``, by properly setting its input arguments:

.. code-block:: perl

   my ($goedges, $parentIndex, $childIndex)= ("example/data/gobasic-edgesBP.txt", 0, 1);
   my $res= obogaf::parser::make_stat($goedges, $parentIndex, $childIndex);
   print "$res";

   ## results returned on the shell
   oboterm <tab> degree <tab> indegree <tab> outdegree
   #oboterm <tab> degree <tab> indegree <tab> outdegree
   GO:0048856  199   1  198
   GO:0003006  172   2  170
   GO:0051241  136   2  134
   GO:0051240  129   2  127
   GO:0014070  128   1  127
   GO:1901700  112   1  111
   GO:0022414  110   2  108
   GO:0048646  108   2  106
   GO:0031328  105   3  102
   GO:1901361  105   2  103
   .
   .
   .
   ~summary stat~
   nodes: 29457
   edges: 62232
   max degree: 199
   min degree: 1
   median degree: 3.0000
   average degree: 2.1126
   density: 7.1722e-05

``obogaf::parser`` computes also the parents and children list for each node of the graph:

.. code-block:: perl
   
   my $parlist= "gobasic-parGO.txt";
   my ($goedges, $parentIndex, $childIndex)= ("example/data/gobasic-edges.txt", 1, 2);
   my $pares= obogaf::parser::get_parents_or_children_list($goedges, $parentIndex, $childIndex, "parents");
   open FH, "> $parlist";
   foreach my $k (sort{$a cmp $b} keys %$pares) { print FH "$k $$pares{$k}\n";} ## parents  list
   close FH;

   my $chdlist= "gobasic-chdGO.txt";
   my $chdres= obogaf::parser::get_parents_or_children_list($goedges, $parentIndex, $childIndex, "children");
   open FH, "> $chdlist";
   foreach my $k (sort{$a cmp $b} keys %$chdres) { print FH "$k $$chdres{$k}\n";} ## children list
   close FH;

Below we show few lines of ``gobasic-parGO.txt`` as example:

.. code-block:: text

   GO:0000001 GO:0048308|GO:0048311
   GO:0000002 GO:0007005
   GO:0000003 GO:0008150
   GO:0000006 GO:0005385
   GO:0000007 GO:0005385
   GO:0000009 GO:0000030
   GO:0000010 GO:0016765
   GO:0000011 GO:0007033|GO:0048308
   GO:0000012 GO:0006281
   GO:0000014 GO:0004520
   GO:0000015 GO:1902494|GO:0005829
   GO:0000016 GO:0004553
   GO:0000017 GO:0042946
   GO:0000018 GO:0051052
   GO:0000019 GO:0000018
   GO:0000022 GO:0051231|GO:1903047|GO:0000070|GO:0007052
   GO:0000023 GO:0005984
   GO:0000024 GO:0000023|GO:0046351
   GO:0000025 GO:0000023|GO:0046352
   GO:0000026 GO:0000030

   ... to be continued ...

The first column contains a ``GO`` term whereas the second one contains the list (pipe separated) of its parent terms. The file ``gobasic-chdGO.txt`` has the same structure, but instead of parents list contains the children list.

Obviously, ``obogaf::parser::get_parents_or_children_list`` can also be run on a subontology file (e.g. ``gobasic-edgesBP.txt``). The only thing to do is to proper set the parameters ``$parentIndex`` and ``$childIndex``.

Parse the GOA annotation file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``obogaf::parser`` can be also used to parse the annotation file taken from the Gene Ontology Annotation (``GOA``) Database (`link <https://www.ebi.ac.uk/GOA>`_). 

For the examples shown below we use the annotation file of the ``CHICKEN`` model organism (release ``7/29/19``), but of course ``obogaf::parser`` subroutines can be applied to parse the annotation file of any other organisms listed in the ``GOA`` database and more in general to parse any file structured as those listed in the ``GOA`` database. 

----

NOTE: the annotation file on ``GOA`` website are monthly updated. The release used at the time of writing this tutorial is July release (``2019-11-11``).

----

First we must download the annotation file in the ``example/data`` folder (note that the link show below refers to the most updated release):

.. code-block:: bash

   $ cd example/data && wget ftp://ftp.ebi.ac.uk/pub/databases/GO/goa/CHICKEN/goa_chicken.gaf.gz -O goa_chicken.gaf.gz

By having a look to the ``goa_chicken.gaf.gz`` file we see that it is structured as follow (for the sake of space we display just the first ``20`` lines):

.. code-block:: text

   !gaf-version: 2.1
   !
   !The set of protein accessions included in this file is based on UniProt reference proteomes, which provide one protein per gene.
   !They include the protein sequences annotated in Swiss-Prot or the longest TrEMBL transcript if there is no Swiss-Prot record.
   !If a particular protein accession is not annotated with GO, then it will not appear in this file.
   !
   !Note that the annotation set in this file is filtered in order to reduce redundancy; the full, unfiltered set can be found in
   !ftp://ftp.ebi.ac.uk/pub/databases/GO/goa/UNIPROT/goa_uniprot_all.gz
   !
   !Generated: 2019-11-11 15:58
   !GO-version: http://purl.obolibrary.org/obo/go/releases/2019-11-09/extensions/go-plus.owl
   !
   UniProtKB   A0A088BIK7  EDbeta      GO:0005200  GO_REF:0000002 IEA   InterPro:IPR003461   F  Keratin  EDbeta|EDBETA  protein  taxon:9031  20191109 InterPro    
   UniProtKB   A0A088BIK7  EDbeta      GO:0005882  GO_REF:0000038 IEA   UniProtKB-KW:KW-0416 C  Keratin  EDbeta|EDBETA  protein  taxon:9031  20191109 UniProt     
   UniProtKB   A0A088BIK7  EDbeta      GO:0007010  GO_REF:0000108 IEA   GO:0005200  P  Keratin  EDbeta|EDBETA  protein  taxon:9031  20191109 GOC      
   UniProtKB   A0A0A0MQ32  LOXL2    GO:0000122  GO_REF:0000107 IEA   UniProtKB:Q9Y4K0|ensembl:ENSP00000373783  P  Lysyl oxidase homolog 2 LOXL2 protein  taxon:9031  20191109 Ensembl     
   UniProtKB   A0A0A0MQ32  LOXL2    GO:0000785  GO_REF:0000107 IEA   UniProtKB:Q9Y4K0|ensembl:ENSP00000373783  C  Lysyl oxidase homolog 2 LOXL2 protein  taxon:9031  20191109 Ensembl     
   UniProtKB   A0A0A0MQ32  LOXL2    GO:0001666  GO_REF:0000107 IEA   UniProtKB:P58022|ensembl:ENSMUSP00000022660  P  Lysyl oxidase homolog 2 LOXL2 protein  taxon:9031  20191109 Ensembl     
   UniProtKB   A0A0A0MQ32  LOXL2    GO:0001837  GO_REF:0000107 IEA   UniProtKB:Q9Y4K0|ensembl:ENSP00000373783  P  Lysyl oxidase homolog 2 LOXL2 protein  taxon:9031  20191109 Ensembl     
   UniProtKB   A0A0A0MQ32  LOXL2    GO:0001935  GO_REF:0000107 IEA   UniProtKB:Q9Y4K0|ensembl:ENSP00000373783  P  Lysyl oxidase homolog 2 LOXL2 protein  taxon:9031  20191109 Ensembl  

   ... to be continued ...

Now we can build the list of annotations by using the subroutine ``gene2biofun``. The input arguments required are:


#. ``$inputfile``: ``GOA`` annotation file for the ``CHICKEN`` organism;
#. ``$geneindex``: and ``$geneindex``: index referring respectively to the column containing the proteins and the ``GO`` term in the ``$inputfile`` file.

.. code-block:: perl

   my ($inputfile, $geneindex, $classindex)= ("example/data/goa_chicken.gaf.gz", 1, 4);
   my ($res, $stat)= obogaf::parser::gene2biofun($inputfile, $geneindex, $classindex);

   my $goaout= "example/data/chicken.uniprot2go.txt";
   open OUT, "> $goaout";
   foreach my $k (sort{$a cmp $b} keys %$res) { print OUT "$k $$res{$k}\n";} 
   close OUT;
   print "${$stat}\n";

   ## results printed on the shell
   genes: 15695
   ontology terms: 13953

``gene2biofun`` returns a list of two anonymous references. The first is an anonymous hash storing for each UniProtKB protein all its associated ``GO`` terms (pipe separated). The second is an anonymous scalar containing basic statistics such as the total unique number of proteins and ontology terms. In the example above the anonymous hash is addressed in the output file ``example/data/chicken.uniprot2go.txt`` and the stats are printed on the shell. Finally, it is worth noting that ``gene2biofun`` can handle both compress ``.gz`` file and plain ``.txt`` file. Below we report as an example a snapshot of the associations between UniProtKB entry and ``GO`` terms obtained by running ``gene2biofun`` and stored in the file ``example/data/chicken.uniprot2go.txt`` (``head -n10 example/data/chicken.uniprot2go.txt``):

.. code-block:: text

   A0A088BIK7 GO:0005200|GO:0005882|GO:0007010
   A0A0A0MQ32 GO:0000122|GO:0000785|GO:0001666|GO:0001837|GO:0001935|GO:0002040|GO:0004720|GO:0005044|GO:0005507|GO:0005509|GO:0005615|GO:0005654|GO:0005783|GO:0006897|GO:0010718|GO:0016020|GO:0018057|GO:0030199|GO:0032332|GO:0043542|GO:0046688|GO:0070492|GO:0070828|GO:1902455
   A0A0A0MQ34 GO:0009374
   A0A0A0MQ35 GO:0000421|GO:0005654|GO:0005765|GO:0016021|GO:0032266|GO:0097352
   A0A0A0MQ36 GO:0005246|GO:0005509|GO:0007165
   A0A0A0MQ42 GO:0005654|GO:0005794|GO:0019221|GO:0030368
   A0A0A0MQ45 GO:0000086|GO:0004674|GO:0005524|GO:0005634|GO:0005654|GO:0005813|GO:0007147|GO:0018105|GO:0032154|GO:0032515|GO:0035556|GO:0051726|GO:1904668
   A0A0A0MQ47 GO:0000122|GO:0000993|GO:0002039|GO:0005634|GO:0005829|GO:0008285|GO:0010452|GO:0018024|GO:0018026|GO:0018027|GO:0034968|GO:0043516|GO:0046975
   A0A0A0MQ52 GO:0000724|GO:0003678|GO:0003682|GO:0003682|GO:0003688|GO:0003697|GO:0005524|GO:0005634|GO:0006270|GO:0007292|GO:0019899|GO:0032406|GO:0032407|GO:0032408|GO:0032508|GO:0036298|GO:0036298|GO:0042555|GO:0070716|GO:0070716|GO:0071168|GO:0097362|GO:0097362
   A0A0A0MQ56 GO:0005615|GO:0005623|GO:0010975|GO:1990830|GO:0005874

   ... to be continued...

Map GO terms between releases
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In time-lapse hold-out experiments we use annotations of an old ``GO`` release to predict the protein function of a more recent ``GO`` release. However, between different ``GO`` releases some ontology terms could be removed, others changed or become obsolete. Then before beginning time-lapse hold-out experiments, we need to map the old ``GO`` terms to the new ones by parsing the annotation file of an *old* ``GO`` release using as **key** the *alt-ID* taken from the obo file of the *new* ``GO`` release . The subroutine ``map_OBOterm_between_release`` does that for us.

Firstly, we must download the old annotation file of the ``CHICKEN`` organism in the ``example/data`` directory (here we use the ``07/06/16`` release):

.. code-block:: bash

   $ cd example/data && wget ftp://ftp.ebi.ac.uk/pub/databases/GO/goa/old/CHICKEN/goa_chicken.gaf.128.gz -O goa_chicken.gaf.128.gz

The input arguments required by ``map_OBOterm_between_release`` are:


#. ``$obofile``: the *new* release of a ``GO`` obo file (here we use the ``01/07/19`` release). This file is used to make the ``alt_id - id`` pairing by using ``alt_id`` as key;
#. ``$goafileOld``: the *old* release of an annotation file (for this example we use ``07/06/16`` release);
#. ``$classindex``: the index referring to the column of the ``$goafileOld`` containing the ontology terms to be mapped (in the ``GOA`` file the ``GO`` terms are in the 4 columns -- NB: we must start to count from zero).

.. code-block:: perl

   my ($obofile, $goafileOld, $classindex)= ("example/data/gobasic.obo", "example/data/goa_chicken.gaf.128.gz", 4);
   my ($res, $stat)= obogaf::parser::map_OBOterm_between_release($obofile, $goafileOld, $classindex);

   my $mapfile= "example/data/chicken.goa.mapped.txt";
   open OUT, "> $mapfile"; 
   print OUT "${$res}";
   close OUT;
   print "${$stat}";

   # results printed on the shell
   #alt-id <tab> id
   GO:0000042  GO:0034067
   GO:0000975  GO:0044212
   GO:0000982  GO:0000981
   GO:0000983  GO:0016251
   GO:0001075  GO:0016251
   GO:0001077  GO:0001228
   GO:0001078  GO:0001227
   GO:0001104  GO:0003712
   GO:0001105  GO:0003713
   GO:0001106  GO:0003714
   .
   .
   .
   Tot. ontology terms: 12546
   Tot. altID: 2617
   Tot. altID seen:  201
   Tot. altID unseen:   2416

The ``map_OBOterm_between_release`` subroutine returns a list of two anonymous references. The first is an anonymous scalar storing the annotations file in the same format of the input file but with the *obsolete* ontology terms substituted with the *updated* ones. The second reference is an anonymous scalar containing some basic statistics, such as the total unique number of ontology terms (of the old release) and the total number of mapped and unmapped *altID* ontology terms. In addition, all the found pairs ``alt_id - id`` are returned. In the example run above the anonymous hash is addressed in the output file ``example/data/chicken.goa.mapped.txt`` whereas the stats are printed on the shell. 

The difference between the *old* and the *mapped* file can be easily displayed by using the ``diff`` command (in a Linux environment):

.. code-block:: bash

   $ cd example/data && gunzip -k goa_chicken.gaf.128.gz
   $ diff goa_chicken.gaf.128 chicken.goa.mapped.txt > go.ann.diff

To give an example, below we show the first ``23`` lines of the file ``go.ann.diff``:

.. code-block:: diff

   75c75
   < UniProtKB A0AVX7   TESC     GO:0072661  GO_REF:0000024 ISS   UniProtKB:Q96BS2  P  Calcineurin B homologous protein 3  CHP3_CHICK|TESC|CHP3 protein  taxon:9031  20120627 UniProt     
   ---
   > UniProtKB A0AVX7   TESC     GO:0072659  GO_REF:0000024 ISS   UniProtKB:Q96BS2  P  Calcineurin B homologous protein 3  CHP3_CHICK|TESC|CHP3 protein  taxon:9031  20120627 UniProt     
   159c159
   < UniProtKB A1DYI3   Wnt3     GO:0005578  GO_REF:0000040 IEA   UniProtKB-SubCell:SL-0111  C  Protein Wnt A1DYI3_CHICK|Wnt3|WNT3  protein  taxon:9031  20160507 UniProt     
   ---
   > UniProtKB A1DYI3   Wnt3     GO:0031012  GO_REF:0000040 IEA   UniProtKB-SubCell:SL-0111  C  Protein Wnt A1DYI3_CHICK|Wnt3|WNT3  protein  taxon:9031  20160507 UniProt     
   234,235c234,235
   < UniProtKB A1KXM5   SPERT    GO:0016023  GO_REF:0000019 IEA   Ensembl:ENSMUSP00000127439 C  Spermatid-associated protein  SPERT_CHICK|SPERT protein  taxon:9031  20160507 Ensembl     
   < UniProtKB A1XGV6   TNFRSF19    GO:0004872  GO_REF:0000033 IBA   PANTHER:PTN000950406 F  Troy-long   A1XGV6_CHICK|TNFRSF19   protein  taxon:9031  20160114 GO_Central     
   ---
   > UniProtKB A1KXM5   SPERT    GO:0031410  GO_REF:0000019 IEA   Ensembl:ENSMUSP00000127439 C  Spermatid-associated protein  SPERT_CHICK|SPERT protein  taxon:9031  20160507 Ensembl     
   > UniProtKB A1XGV6   TNFRSF19    GO:0038023  GO_REF:0000033 IBA   PANTHER:PTN000950406 F  Troy-long   A1XGV6_CHICK|TNFRSF19   protein  taxon:9031  20160114 GO_Central     
   268c268
   < UniProtKB A3F962   MBNL2    GO:0044822  GO_REF:0000019 IEA   Ensembl:ENSP00000365861 F  Muscleblind-like 2 isoform 1  A3F962_CHICK|MBNL2   protein  taxon:9031  20160507 Ensembl     
   ---
   > UniProtKB A3F962   MBNL2    GO:0003723  GO_REF:0000019 IEA   Ensembl:ENSP00000365861 F  Muscleblind-like 2 isoform 1  A3F962_CHICK|MBNL2   protein  taxon:9031  20160507 Ensembl     
   286c286
   < UniProtKB A4GTP0   A4GTP0      GO:0044822  GO_REF:0000019 IEA   Ensembl:ENSP00000254301 F  Galectin A4GTP0_CHICK   protein  taxon:9031  20160507 Ensembl     
   ---
   > UniProtKB A4GTP0   A4GTP0      GO:0003723  GO_REF:0000019 IEA   Ensembl:ENSP00000254301 F  Galectin A4GTP0_CHICK   protein  taxon:9031  20160507 Ensembl     
   321c321

Application to Human Phenotype Ontology (HPO)
---------------------------------------------

Here we show how to use ``obogaf::parser`` on the ``HPO`` obo file and its annotation file. Here we go faster, because the experiments are carried-out in the same way of those shown above with the ``GO``. 

Parse the HPO obo file
~~~~~~~~~~~~~~~~~~~~~~

Here we use ``obogaf::parser`` to handle the ``HPO`` obo file and return some basic statistics. For this example we use the ``2019-11-08`` ``HPO`` obo release.

.. code-block:: perl

   #!/usr/bin/perl

   ## loading obogaf::parser and useful Perl module
   use strict;
   use warnings;
   use File::Path qw(make_path); ## to recursively create directories 
   use obogaf::parser; 

   ## create folder where storing example data
   my $basedir= "example/data/";
   make_path($basedir) unless(-d $basedir);

   ## download HPO obo file
   my $obofile= $basedir."hpo.obo";
   my $hpobo= qx{wget --output-document=$obofile http://purl.obolibrary.org/obo/hp.obo};
   print "HPO obo file downloaded: done\n\n";

   ## extract edges from HPO obo file
   my $hpores= obogaf::parser::build_edges($obofile);
   my $hpoedges= $basedir."hpo-edges.txt"; ## hpo edges file declared here 
   open OUT, "> $hpoedges"; ## redirect hpo edges on file
   print OUT "${$hpores}"; ## scalar dereferencing
   close OUT;
   print "build HPO edges: done\n\n";

   ## compute parents and children list on HPO ontology
   my $parlist= $basedir."gobasic-parHPO.txt";
   my $pares= obogaf::parser::get_parents_or_children_list($hpoedges, 0,1, "parents");
   open FH, "> $parlist";
   foreach my $k (sort{$a cmp $b} keys %$pares) { print FH "$k $$pares{$k}\n";} ## parents  list
   close FH;

   my $chdlist= $basedir."gobasic-chdHPO.txt";
   my $chdres= obogaf::parser::get_parents_or_children_list($hpoedges, 0,1, "children");
   open FH, "> $chdlist";
   foreach my $k (sort{$a cmp $b} keys %$chdres) { print FH "$k $$chdres{$k}\n";} ## children list
   close FH;
   print "\nHPO parents/children list: done\n\n";

   ## make stats on HPO 
   my ($parentIndex, $childIndex)= (0,1);
   my $res= obogaf::parser::make_stat($hpoedges, $parentIndex, $childIndex);
   print "$res"; ## print stats on shell
   
   ## results printed on the shell
   #oboterm <tab> degree <tab> indegree <tab> outdegree
   HP:0003110  60 2  58
   HP:0012379  45 1  44
   HP:0010876  42 1  41
   HP:0000708  39 1  38
   HP:0011805  39 1  38
   HP:0003355  37 1  36
   HP:0012531  36 1  35
   HP:0030057  34 1  33
   HP:0001760  31 1  30
   HP:0008069  31 2  29
   .
   .
   ~summary stat~
   nodes: 14586
   edges: 18416
   max degree: 60
   min degree: 1
   median degree: 1.0000
   average degree: 1.2626
   density: 8.6567e-05
   
Parse the HPO annotation file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here we use ``obogaf::parser`` to parse the ``HPO`` annotation file (release ``2019-11-08``)

.. code-block:: perl

   #!/usr/bin/perl

   ## loading obogaf::parser and useful Perl module
   use strict;
   use warnings;
   use File::Path qw(make_path); ## to recursively create directories 
   use obogaf::parser; 

   ## create folder where storing data
   my $basedir= "example/data/";
   make_path($basedir) unless(-d $basedir);

   ## download HPO annotations 
   my $hpofile= $basedir."hpo.ann.txt"; ## hpo annotation file declared here
   my $hpoann= qx{wget --output-document=$hpofile http://compbio.charite.de/jenkins/job/hpo.annotations.monthly/lastStableBuild/artifact/annotation/ALL_SOURCES_ALL_FREQUENCIES_genes_to_phenotype.txt};

   ## extract HPO annotations 
   my ($geneindex, $classindex)= (1,3);
   my ($res, $stat)= obogaf::parser::gene2biofun($hpofile, $geneindex, $classindex);
   my $hpout= $basedir."hpo.gene2pheno.txt"; ## annotation adj list stored in a file
   open OUT, "> $hpout";
   foreach my $k (sort{$a cmp $b} keys %$res) { print OUT "$k $$res{$k}\n";} ## dereferencing
   close OUT;
   print "${$stat}\n";

   ## results printed on the shell
   genes: 4293
   ontology terms: 7729

Below we show the first ``10`` lines of the ``hpo.gene2pheno.txt`` file, just to give an example of how this file is structured:

.. code-block:: text

   A2M HP:0410054|HP:0001425|HP:0001300|HP:0000006|HP:0000726|HP:0002423|HP:0002185|HP:0002511
   A2ML1 HP:0000768|HP:0001156|HP:0000006|HP:0000391|HP:0000520|HP:0001928|HP:0100625|HP:0000403|HP:0000407|HP:0011800|HP:0011675|HP:0000028|HP:0002974|HP:0002208|HP:0008872|HP:0000044|HP:0001324|HP:0000179|HP:0007477|HP:0000316|HP:0005692|HP:0002750|HP:0004415|HP:0002240|HP:0000325|HP:0010318|HP:0001743|HP:0000465|HP:0006610|HP:0000218|HP:0002650|HP:0000474|HP:0000347|HP:0000348|HP:0000476|HP:0011869|HP:0011362|HP:0004322|HP:0000995|HP:0001252|HP:0001892|HP:0000486|HP:0010982|HP:0001641|HP:0001004|HP:0001260|HP:0000494|HP:0000368|HP:0004209|HP:0002162|HP:0011381|HP:0000508|HP:0000639|HP:0000767
   A4GALT HP:0000006|HP:0010970
   AAAS HP:0001347|HP:0008259|HP:0007556|HP:0011463|HP:0000007|HP:0002376|HP:0000648|HP:0000649|HP:0000522|HP:0002571|HP:0000972|HP:0000846|HP:0007440|HP:0001430|HP:0000982|HP:0000407|HP:0007002|HP:0003676|HP:0003487|HP:0004319|HP:0001761|HP:0001249|HP:0004322|HP:0001250|HP:0001251|HP:0008163|HP:0001252|HP:0000612|HP:0001324|HP:0001260|HP:0012332|HP:0002093|HP:0001263|HP:0010486|HP:0000505|HP:0000953|HP:0000252|HP:0009916|HP:0000830|HP:0001278
   AAGAB HP:0003584|HP:0040162|HP:0025092|HP:0000006|HP:0007530|HP:0002894|HP:0005584|HP:0001425|HP:0006740|HP:0000982|HP:0025114|HP:0003002|HP:0003003|HP:0001597|HP:0012189
   AARS1 HP:0003202|HP:0000643|HP:0001284|HP:0000006|HP:0000007|HP:0000648|HP:0001290|HP:0002059|HP:0002827|HP:0002317|HP:0002063|HP:0001298|HP:0003477|HP:0001558|HP:0000407|HP:0002072|HP:0002460|HP:0000668|HP:0012447|HP:0000546|HP:0002355|HP:0100660|HP:0001336|HP:0001337|HP:0011968|HP:0009027|HP:0200134|HP:0002376|HP:0002509|HP:0000717|HP:0002133|HP:0002521|HP:0010844|HP:0000348|HP:0001761|HP:0001249|HP:0001250|HP:0004322|HP:0001251|HP:0001508|HP:0002020|HP:0001765|HP:0003429|HP:0009830|HP:0003431|HP:0001511|HP:0100710|HP:0001257|HP:0007018|HP:0000750|HP:0000494|HP:0001263|HP:0001265|HP:0003828|HP:0001268|HP:0002421|HP:0002936|HP:0000504|HP:0003577|HP:0001273|HP:0000252|HP:0000508|HP:0000639
   AARS2 HP:0002371|HP:0006980|HP:0002180|HP:0000007|HP:0002186|HP:0000716|HP:0008209|HP:0000726|HP:0003676|HP:0001251|HP:0001508|HP:0002151|HP:0001639|HP:0001257|HP:0002089|HP:0001260|HP:0002353|HP:0001522|HP:0001332|HP:0001272|HP:0003128|HP:0001337|HP:0006970|HP:0003324|HP:0000639
   AASS HP:0000736|HP:0001249|HP:0003297|HP:0004322|HP:0001250|HP:0001252|HP:0000007|HP:0001256|HP:0003593|HP:0032397|HP:0000750|HP:0002927|HP:0001903|HP:0001264|HP:0000752|HP:0002353|HP:0002161|HP:0000119|HP:0001083|HP:0100543
   ABAT HP:0000098|HP:0001250|HP:0001347|HP:0001254|HP:0000007|HP:0001321|HP:0003819|HP:0025356|HP:0006829|HP:0000494|HP:0002415|HP:0001263|HP:0000278|HP:0025430|HP:0001274|HP:0007291
   ABCA1 HP:0002240|HP:0003457|HP:0100546|HP:0003396|HP:0001349|HP:0000006|HP:0000007|HP:0025608|HP:0003146|HP:0010829|HP:0001677|HP:0004943|HP:0007759|HP:0000656|HP:0001744|HP:0001873|HP:0008404|HP:0007957|HP:0003477|HP:0004374|HP:0011096|HP:0001433|HP:0005145|HP:0002460|HP:0002716|HP:0007133|HP:0030814|HP:0000991|HP:0007328|HP:0003233|HP:0002730|HP:0002027|HP:0002155|HP:0003693|HP:0000622|HP:0001903|HP:0001712|HP:0001392|HP:0001265|HP:0002164|HP:0006901|HP:0000505|HP:0001658|HP:0005181|HP:0000958

   ... to be continued ...

Map HPO terms between releases
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here we use ``obogaf::parser`` to map the ``HPO`` terms of an *old* release (``2018-09-03``) toward a *new* ones (``2019-11-08``).

.. code-block:: perl

   #!/usr/bin/perl

   ## loading obogaf::parser and useful Perl module
   use strict;
   use warnings;
   use File::Path qw(make_path); ## to recursively create directories 
   use obogaf::parser; 

   ## create folder where storing data
   my $basedir= "example/data/";
   make_path($basedir) unless(-d $basedir);

   ## download HPO obo file
   my $obofile= $basedir."hpo.obo";
   my $hpobo= qx{wget --output-document=$obofile http://purl.obolibrary.org/obo/hp.obo};

   ## download HPO old annotation file
   my $hpofileOld= $basedir."hpo.ann.old.txt"; ## goa annotation file declared here
   my $hpold= qx{wget --output-document=$hpofileOld http://compbio.charite.de/jenkins/job/hpo.annotations.monthly/139/artifact/annotation/ALL_SOURCES_ALL_FREQUENCIES_genes_to_phenotype.txt};

   ## map HPO terms between releases
   my $classindex= 3;
   my ($res, $stat)= obogaf::parser::map_OBOterm_between_release($obofile, $hpofileOld, $classindex);
   my $mapfile= $basedir."hpo.ann.mapped.txt";
   open OUT, "> $mapfile"; ## mapped annotation stored in a file
   print OUT "${$res}";
   close OUT;
   print "${$stat}";

   #alt-id <tab> id
   HP:0000487  HP:0000486
   HP:0000547  HP:0000510
   HP:0000655  HP:0007773
   HP:0000833  HP:0001952
   HP:0001226  HP:0006121
   HP:0001322  HP:0006872
   HP:0001472  HP:0001426
   HP:0001862  HP:0006121
   HP:0002271  HP:0012332
   HP:0002281  HP:0002282
   HP:0002459  HP:0012332
   HP:0003464  HP:0003107
   HP:0003490  HP:0003150
   HP:0005130  HP:0001723
   HP:0005364  HP:0004429
   HP:0005901  HP:0002754
   HP:0006830  HP:0001319
   HP:0007314  HP:0002282
   HP:0007519  HP:0007485
   HP:0007713  HP:0010920
   HP:0007758  HP:0000505
   HP:0007868  HP:0000608
   HP:0007893  HP:0000546
   HP:0008012  HP:0000545
   HP:0008024  HP:0100018
   HP:0008230  HP:0040171
   HP:0010700  HP:0000518
   HP:0011146  HP:0002384
   HP:0012201  HP:0008151
   HP:0040290  HP:0003011
   HP:0045016  HP:0003455

   Tot. ontology terms: 6789
   Tot. altID: 3635
   Tot. altID seen:  31
   Tot. altID unseen:   3604

By running the ``diff`` command between the *old* file (``hpo.ann.old.txt``) and the *mapped* one (``hpo.ann.mapped.txt``) and redirecting the results on a output file (e.g.: ``diff hpo.ann.old.txt hpo.ann.mapped.txt > hpo.ann.diff``) we can easily visualize the changed ``HPO`` terms between the two release. Below  we show just some few lines of ``hpo.ann.diff`` to give an example:

.. code-block:: diff

   1148c1148
   < 51  ACOX1 Tapetoretinal degeneration HP:0000547
   ---
   > 51  ACOX1 Tapetoretinal degeneration HP:0000510
   3423c3423
   < 190 NR0B1 Decreased testosterone in males  HP:0008230
   ---
   > 190 NR0B1 Decreased testosterone in males  HP:0040171
   4041c4041
   < 212 ALAS2 Glucose intolerance  HP:0000833
   ---
   > 212 ALAS2 Glucose intolerance  HP:0001952
   5049c5049
   < 8481   OFD1  Gray matter heterotopias   HP:0002281
   ---
   > 8481   OFD1  Gray matter heterotopias   HP:0002282
   6597c6597
   < 57724  EPG5  White matter neuronal heterotopia   HP:0007314
   ---
   > 57724  EPG5  White matter neuronal heterotopia   HP:0002282
   7244c7244
   < 429 ASCL1 Dysautonomia   HP:0002459
   ---
   > 429 ASCL1 Dysautonomia   HP:0012332
   7246c7246
