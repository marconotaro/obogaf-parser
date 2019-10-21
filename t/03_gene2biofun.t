use Test::More tests => 2;
use Test::Files;
use obogaf::parser;

my $goafile= "t/data/test_goa_chicken.gaf"; 
my ($geneindex, $classindex)= (1, 4);
my ($res,$stat)= obogaf::parser::gene2biofun($goafile, $geneindex, $classindex);
my $goaout= "t/data/test_chicken.uniprot2go.txt";
open my $fh, ">", $goaout;
foreach my $k (sort{$a cmp $b} keys %$res) { print $fh "$k $$res{$k}\n";} 
close $fh;
my $res= ${$stat};

file_ok($goaout, "F1NW72 GO:0048484|GO:0007018|GO:0016887\nF1NW73 GO:0005319|GO:0005524|GO:0006869\n", "test that gene2biofun works");
is($res, "genes: 2\nontology terms: 6\n", "test that gene2biofun stats are ok");