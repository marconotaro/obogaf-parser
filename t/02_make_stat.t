use Test::More tests => 2;
use Test::Files;
use obogaf::parser;

my ($parentIndex, $childIndex) = (0,0);
my $goedges= "t/data/test_gobasic_edges.txt"; 
my $subontoedges= "t/data/test_gobasic_edgesMF.txt";

($parentIndex, $childIndex)= (1,2);
$res= obogaf::parser::make_stat($goedges, $parentIndex, $childIndex);
is($res, "#oboterm <tab> degree <tab> indegree <tab> outdegree\nGO:0001227\t2\t2\t0\nGO:0000981\t1\t0\t1\nGO:0001217\t1\t0\t1\n\n~summary stat~\nnodes: 3\nedges: 2\nmax degree: 2\nmin degree: 1\nmedian degree: 1.0000\naverage degree: 0.6667\ndensity: 3.3333e-01\n", "test that make_stat works on whole ontology");

($parentIndex, $childIndex)= (0,1);
$res= obogaf::parser::make_stat($subontoedges, $parentIndex, $childIndex);
is($res, "#oboterm <tab> degree <tab> indegree <tab> outdegree\nGO:0001227\t2\t2\t0\nGO:0000981\t1\t0\t1\nGO:0001217\t1\t0\t1\n\n~summary stat~\nnodes: 3\nedges: 2\nmax degree: 2\nmin degree: 1\nmedian degree: 1.0000\naverage degree: 0.6667\ndensity: 3.3333e-01\n", "test that make_stat works on MF subontology");
