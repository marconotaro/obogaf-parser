#!/usr/bin/perl

use strict;
use warnings;
use Badge::Simple qw/badge/;

badge( left => "downloads",    right => "unknown",        color => "yellow" )->toFile( "cpan-downloads.svg"    );
badge( left => "Last updated", right => "check MetaCPAN", color => "blue"   )->toFile( "cpan-last-updated.svg" );
