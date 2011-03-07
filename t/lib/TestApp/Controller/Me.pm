package TestApp::Controller::Me;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => q{});


sub init : Chained('/') PathPart('my') CaptureArgs(0) {
    my ( $self, $ctx )    = @_;
    $ctx->stash->{token}  = ( split /\s+/, $ctx->req->header('authorization') )[1];
}

sub my_test: Chained('init') PathPart('test') Args(0) {
    my ( $self, $ctx ) = @_;
    if ( $ctx->user && ( $ctx->user->{token} eq $ctx->stash->{token} ) ) {
        my %test_data = ( "first_name"    =>  "warachet",
                          "last_name"     =>  "samtalee", ); #testing
        $ctx->stash->{info}  = \%test_data;
    } else {
        $ctx->stash->{error} = "Bad request invalid token";
    }
    $ctx->forward($ctx->view('JSON'));
}

__PACKAGE__->meta->make_immutable;

1;