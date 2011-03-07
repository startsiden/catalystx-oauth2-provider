#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

# make sure testapp works
use ok 'TestApp';

# a live test against TestApp, the test application
use Test::WWW::Mechanize::Catalyst 'TestApp';
my $mech = Test::WWW::Mechanize::Catalyst->new;
$mech->get_ok('http://localhost/', 'get main page');
$mech->content_like(qr/it works/i, 'see if it has our text');

subtest 'simple test for endpoint', sub {
    $mech->get_ok('http://localhost/oauth/token?client_id=36d24a484e8782decbf82a46459220a10518239e', 'a token endpoint');
    $mech->get('http://localhost/oauth/authorize?client_id=947da6393f802a7abe4ecf17ff12cc3f10704ee4', 'an authorize endpoint');
    is( $mech->status, 403, "Login required" );
};

done_testing;
