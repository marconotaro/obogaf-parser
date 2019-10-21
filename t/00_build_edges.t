use Test::More tests => 1;
use Test::Files;
use obogaf::parser;

my $obofile= "t/data/test_gobasic.obo";
my $gores= obogaf::parser::build_edges($obofile);
my $goedges= "t/data/test_gobasic_edges.txt"; 
open my $fh, ">", $goedges; 
print $fh "${$gores}";
close $fh;

file_ok($goedges, "molecular_function\tGO:0000981\tGO:0001227\tis-a\nmolecular_function\tGO:0001217\tGO:0001227\tis-a\n", "test that build_edges works");
