package CatalystX::OAuth2::Provider::TraitFor::Controller::OAuth::AuthorizationCode;

use MooseX::MethodAttributes::Role;
use namespace::autoclean;

requires qw/
    handle_grant_type
/;

around 'handle_grant_type' => sub {
    my ( $orig, $self, $ctx, $grant_type ) = @_;
    if ( $grant_type && ( $grant_type eq 'authorization_code' ) ) {
        my %test_data = ( "access_token"  =>  $ctx->user->{token},
                          "expires_in"    =>   3600,
                          "scope"         =>   undef,
                          "refresh_token" => $ctx->user->{token} ); #testing
        $ctx->res->body( JSON::XS->new->pretty(1)->encode( \%test_data ) );
        $ctx->detach();
    }
};

=pod
=cut

1;