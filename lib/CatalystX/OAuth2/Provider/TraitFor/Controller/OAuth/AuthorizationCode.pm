package CatalystX::OAuth2::Provider::TraitFor::Controller::OAuth::AuthorizationCode;

use MooseX::MethodAttributes::Role;
use namespace::autoclean;

requires qw/
    token
/;

after 'token' => sub {
    my ( $self, $ctx ) = @_;
    warn "LOAD OAuth::Lite2::Server::GrantHandler::AuthorizationCode to HANDLE AUTHORIZATION CODE HERE";
};

=pod
=cut

1;