#!/usr/bin/perl

## loading obogaf::parser and 
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

## note: if you want to store data in your home, use File::HomeDir
# use File::HomeDir qw(home);
# my $basedir = File::HomeDir->my_home."/data/";
# mkdir $basedir unless(-e $basedir);

## declare variables 
my ($res, $stat, $parentIndex, $childIndex, $geneindex, $classindex, $parlist, $pares, $chdlist, $chdres); 

## ~~ GO OBO ~~ ## 
## download GO obo file
my $obofile= $basedir."gobasic.obo";
my $gobo= qx{wget --output-document=$obofile http://purl.obolibrary.org/obo/go/go-basic.obo};
print "GO obo file downloaded: done\n\n";

## shrink GO obo file to a subset of terms
my @terms = qw(GO:0000002 GO:0000003 GO:0000018 GO:0000030 GO:0000038);
my $termsfile= $basedir."goterms.txt";
open OUT, "> $termsfile";
foreach my $go (@terms){print OUT "$go\n";}
close OUT;

$res= obo_filter($obofile, $termsfile);
my $newobo= $basedir."go-shrunk.obo"; 
open OUT, ">", $newobo; 
print OUT "${$res}";
close OUT;

## extract edges from GO obo file
my $gores= build_edges($obofile);
my $goedges= $basedir."gobasic-edges.txt"; ## go edges file declared here 
open FH, "> $goedges"; 
print FH "${$gores}"; ## scalar dereferencing
close FH;
print "build GO edges: done\n\n";

## extract GO subontology nodes and relationships
my @domains= qw(biological_process molecular_function cellular_component);
my %aspects= (biological_process => "BP", molecular_function => "MF", cellular_component => "CC");

foreach my $domain (@domains){
    my $outfile= $basedir."gobasic-edges"."$aspects{$domain}".".txt";
    open FH, "> $outfile";
    my $domainres= build_subonto($goedges, $domain);
    print FH "${$domainres}";
    close FH;
}
print "build edges for each GO subontology: done\n\n";

## make stats on the whole GOobo file
($parentIndex, $childIndex)= (1,2);
$res= make_stat($goedges, $parentIndex, $childIndex);
print "$res";
print "\nGO stats: done\n\n";

## make stats on a GO-BP subontology
my $goedgesbp= $basedir."gobasic-edgesBP.txt";
($parentIndex, $childIndex)= (0,1);
$res= make_stat($goedgesbp, $parentIndex, $childIndex);
print "$res";
print "\nGO BP stats: done\n\n";

## compute parents and children list (whole ontology)
$parlist= $basedir."gobasic-parGO.txt";
$pares= get_parents_or_children_list($goedges, 1,2, "parents");
open FH, "> $parlist";
foreach my $k (sort{$a cmp $b} keys %$pares) { print FH "$k $$pares{$k}\n";} ## parents  list
close FH;

$chdlist= $basedir."gobasic-chdGO.txt";
$chdres= get_parents_or_children_list($goedges, 1,2, "children");
open FH, "> $chdlist";
foreach my $k (sort{$a cmp $b} keys %$chdres) { print FH "$k $$chdres{$k}\n";} ## children list
close FH;

print "\nGO parents/children list: done\n\n";

## compute parents and children list (GO-BP subontology)
$parlist= $basedir."gobasic-parGO-BP.txt";
$pares= get_parents_or_children_list($goedgesbp, 0,1, "parents");
open FH, "> $parlist";
foreach my $k (sort{$a cmp $b} keys %$pares) { print FH "$k $$pares{$k}\n";} ## parents  list
close FH;

$chdlist= $basedir."gobasic-chdGO-BP.txt";
$chdres= get_parents_or_children_list($goedgesbp, 0,1, "children");
open FH, "> $chdlist";
foreach my $k (sort{$a cmp $b} keys %$chdres) { print FH "$k $$chdres{$k}\n";} ## children list
close FH;

print "\nGO BP parents/children list: done\n\n";

## ~~ GOA ANNOTATION ~~ ##
## download GO annotation from GOA database (CHICKEN organism)
my $goafile= $basedir."goa_chicken.gaf.gz"; ## goa annotation file declared here
my $goachicken= qx{wget --output-document=$goafile ftp://ftp.ebi.ac.uk/pub/databases/GO/goa/CHICKEN/goa_chicken.gaf.gz};

## extract GO annotation from GOA database (CHICKEN organism)
($geneindex, $classindex)= (1, 4);
($res, $stat)= gene2biofun($goafile, $geneindex, $classindex);
my $goaout= $basedir."chicken.uniprot2go.txt";
open FH, "> $goaout";
foreach my $k (sort{$a cmp $b} keys %$res) { print FH "$k $$res{$k}\n";} ## dereferencing
close FH;
print "${$stat}\n";
print "build GOA annotations (CHICKEN): done\n\n";

## ~~ MAP GO TERMS BETWEEN RELEASE ~~ ## 
## download old GOA CHICKEN annotation file
my $goafileOld= $basedir."goa_chicken.gaf.128.gz"; ## goa annotation file declared here
my $goachickenOld= qx{wget --output-document=$goafileOld ftp://ftp.ebi.ac.uk/pub/databases/GO/goa/old/CHICKEN/goa_chicken.gaf.128.gz};

## map GO terms between release
($res, $stat)= map_OBOterm_between_release($obofile, $goafileOld, $classindex);
my $mapfile= $basedir."chicken.goa.mapped.txt";
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

