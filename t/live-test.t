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

# simple test for endpoint
$mech->get_ok('http://localhost/oauth/token', 'a token endpoint');
$mech->content_like(qr/token/i, 'it has dummy text');

$mech->get_ok('http://localhost/oauth/authorize', 'an authorize endpoint');
$mech->content_like(qr/authorize/i, 'it has dummy text');

done_testing;
