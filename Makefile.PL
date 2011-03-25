use strict;
use warnings;
use inc::Module::Install 0.91;
use Module::Install::AuthorRequires;
use Module::Install::AuthorTests;

name 'CatalystX-OAuth2-Provider';
all_from 'lib/CatalystX/OAuth2/Provider.pm';

requires 'Moose';
requires 'CatalystX::InjectComponent';
requires 'Moose::Autobox';
requires 'Catalyst::Controller::ActionRole';
requires 'OAuth::Lite';
requires 'JSON::XS';
requires 'HTTP::Headers::Util';
requires 'Digest::HMAC_SHA1';
requires 'namespace::autoclean';

build_requires 'Catalyst::Runtime' => '5.80015';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::More' => '0.88';

author_requires 'Test::Pod::Coverage' => '1.04';
author_requires 'Test::Pod' => '1.14';

author_tests 't/author';

resources repository => 'https://github.com/startsiden/catalystx-oauth2-provider';

if ($Module::Install::AUTHOR) {
    system("pod2text lib/CatalystX/OAuth2/Provider.pm > README")
        and die $!;
}

WriteAll();
