use Test::More tests => 2;
use Test::Files;
use obogaf::parser;


my $obofile= "t/data/test_gobasic.obo";
my $goafileOld= "t/data/test_goa_chicken_128.gaf";
my $classindex= 4;
my ($res, $stat)= obogaf::parser::map_OBOterm_between_release($obofile, $goafileOld, $classindex);
my $mapfile= "t/data/test_chicken_goa_mapped.txt"; 
open my $fh, ">", $mapfile; 
print $fh "${$res}";
close $fh;
my $res= ${$stat};

file_ok($mapfile, "UniProtKB\tE1BXP7\tGCFC1\t\tGO:2000288\tGO_REF:0000019\tIEA\tEnsembl:ENSMUSP00000113835\tP\tUncharacterized protein\tE1BXP7_CHICK|GCFC1\tprotein\ttaxon:9031\t20160507\tEnsembl\nUniProtKB\tE1BXP7\tGCFC1\tNOT\tGO:0001227\tGO_REF:0000033\tIBA\tPANTHER:PTN000259148\tF\tUncharacterized protein\tE1BXP7_CHICK|GCFC1\tprotein\ttaxon:9031\t20141217\tGO_Central\nUniProtKB\tE1BXP9\tCKLF\t\tGO:0016021\tGO_REF:0000038\tIEA\tUniProtKB-KW:KW-0812\tC\tUncharacterized protein\tE1BXP9_CHICK|CKLF\tprotein\ttaxon:9031\t20160507\tUniProt\nUniProtKB\tE1BZR5\tBACH2\t\tGO:0001227\tGO_REF:0000019\tIEA\tEnsembl:ENSMUSP00000103815\tF\tUncharacterized protein\tE1BZR5_CHICK|BACH2\tprotein\ttaxon:9031\t20160507\tEnsembl\n", "test that map_OBOterm_between_release works");

is($res, "#alt-id <tab> id\nGO:0001078\tGO:0001227\nGO:0001206\tGO:0001227\n\nTot. ontology terms:\t4\nTot. altID:\t4\nTot. altID seen:\t2\nTot. altID unseen:\t2\n", "test that ap_OBOterm_between_release stats are ok");




