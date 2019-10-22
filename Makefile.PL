use 5.006;
use ExtUtils::MakeMaker;
use Module::Metadata;

WriteMakefile(
    NAME             => 'obogaf::parser',
    VERSION_FROM     => 'lib/obogaf/parser.pm',
    ABSTRACT         => 'a perl5 module to handle obo and gaf file',
    AUTHOR           => 'Marco Notaro',
    LICENSE          => 'perl_5',
    MIN_PERL_VERSION => '5.006',
    PREREQ_PM        => {
        'Graph'            => 0 
    },
    TEST_REQUIRES  => {
        'Test::More'       => 0, 
        'Test::Files'      => 0 
    },
    CONFIGURE_REQUIRES  => {
        'Module::Metadata' => 0,
    },
    META_ADD         => {
        provides  => Module::Metadata->provides(version => '2', dir => 'lib'),
    },
    clean   => {
        FILES   => "t/data/test_chicken_goa_mapped.txt              
                    t/data/test_chicken.uniprot2go.txt
                    t/data/test_gobasic_edgesMF.txt"
    },
    (eval { ExtUtils::MakeMaker->VERSION(6.46) } ? ( 
        META_MERGE => {
            'meta-spec' => { version => 2 },
            resources => {
                repository => {
                    type => 'git',
                    web  => 'https://github.com/marconotaro/obogaf-parser',
                    url  => 'git://github.com/marconotaro/obogaf-parser.git',
                },
            },
            keywords => ['parser', 'obo', 'gaf', 'bio-ontology', 'annotations'],
        }
    ) : () ),
);
