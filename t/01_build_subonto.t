use Test::More tests => 1;
use Test::Files;
use obogaf::parser;

my $goedges= "t/data/test_gobasic_edges.txt"; 
my $domain= "molecular_function";
my $gores= obogaf::parser::build_subonto($goedges, $domain);
my $outfile= "t/data/test_gobasic_edgesMF.txt"; 
open my $fh, ">", $outfile; 
print $fh "${$gores}";
close $fh;

file_ok($outfile, "GO:0000981\tGO:0001227\tis-a\nGO:0001217\tGO:0001227\tis-a\n", "test that build_subonto works");
