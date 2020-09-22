#!/usr/bin/perl

## loading obogaf::parser and useful Perl module
use strict;
use warnings;
use obogaf::parser qw(:all);
## elapased time
use Time::HiRes qw(time);
my $start= time;

## recursively create directories ([-p] mkdir option in perl does not work)
use File::Path qw(make_path);

## create folder where storing example I/O files
my $basedir= "data/";
make_path($basedir) unless(-d $basedir);

## note: if case you want to store data in your home, use File::HomeDir
# use File::HomeDir qw(home);
# my $basedir = File::HomeDir->my_home."/data/";
# mkdir $basedir unless(-e $basedir);

## declare variables
my ($res, $stat, $parentIndex, $childIndex, $geneindex, $classindex, $parlist, $pares, $chdlist, $chdres);

## ~~ HPO OBO ~~ ##
## download HPO obo file
my $obofile= $basedir."hpo.obo";
my $hpobo= qx{wget --output-document=$obofile http://purl.obolibrary.org/obo/hp.obo};
print "HPO obo file downloaded: done\n\n";

## shrink HPO obo file to a subset of terms
my @terms = qw(HP:0001507 HP:0000008 HP:0002719 HP:0000021 HP:0000023);
my $termsfile= $basedir."hpoterms.txt";
open OUT, "> $termsfile";
foreach my $go (@terms){print OUT "$go\n";}
close OUT;

$res= obo_filter($obofile, $termsfile);
my $newobo= $basedir."hpo-shrunk.obo";
open OUT, ">", $newobo;
print OUT "${$res}";
close OUT;

## extract edges from HPO obo file
my $hpores= build_edges($obofile);
my $hpoedges= $basedir."hpo-edges.txt"; ## hpo edges file declared here
open FH, "> $hpoedges";
print FH "${$hpores}"; ## scalar dereferencing
close FH;
print "build HPO edges: done\n\n";

## make stats on HPO
($parentIndex, $childIndex)= (0,1);
$res= make_stat($hpoedges, $parentIndex, $childIndex);
print "$res";
print "\nHPO stats: done\n\n";

## compute parents and children list on HPO ontology
$parlist= $basedir."gobasic-parHPO.txt";
$pares= get_parents_or_children_list($hpoedges, 0,1, "parents");
open FH, "> $parlist";
foreach my $k (sort{$a cmp $b} keys %$pares) { print FH "$k $$pares{$k}\n";} ## parents  list
close FH;

$chdlist= $basedir."gobasic-chdHPO.txt";
$chdres= get_parents_or_children_list($hpoedges, 0,1, "children");
open FH, "> $chdlist";
foreach my $k (sort{$a cmp $b} keys %$chdres) { print FH "$k $$chdres{$k}\n";} ## children list
close FH;

print "\nHPO parents/children list: done\n\n";

## ~~ HPO ANNOTATION ~~ ##
## download HPO annotations
my $hpofile= $basedir."hpo.ann.txt"; ## hpo annotation file declared here
my $hpoann= qx{wget --output-document=$hpofile http://compbio.charite.de/jenkins/job/hpo.annotations.monthly/lastStableBuild/artifact/annotation/ALL_SOURCES_ALL_FREQUENCIES_genes_to_phenotype.txt};

## extract HPO annotations
($geneindex, $classindex)= (1,3);
($res, $stat)= gene2biofun($hpofile, $geneindex, $classindex);
my $hpout= $basedir."hpo.gene2pheno.txt";
open FH, "> $hpout";
foreach my $k (sort{$a cmp $b} keys %$res) { print FH "$k $$res{$k}\n";} ## dereferencing
close FH;
print "${$stat}\n";
print "build HPO annotations: done\n\n";

## ~~ MAP HPO TERMS BETWEEN RELEASE ~~ ##
## download old HPO annotation file
my $hpofileOld= $basedir."hpo.ann.old.txt"; ## goa annotation file declared here
my $hpold= qx{wget --output-document=$hpofileOld http://compbio.charite.de/jenkins/job/hpo.annotations.monthly/139/artifact/annotation/ALL_SOURCES_ALL_FREQUENCIES_genes_to_phenotype.txt};

## map HPO terms between release
($res, $stat)= map_OBOterm_between_release($obofile, $hpofileOld, 3);
my $mapfile= $basedir."hpo.ann.mapped.txt";
open FH, "> $mapfile";
print FH "${$res}";
close FH;
print "${$stat}";

## ~~ ELAPSED TIME ~~ ##
print "\n\n";
my $span= time - $start;
$span= sprintf("%.4f", $span);
printf "Elapased Time:\t$span\n";

exit;


