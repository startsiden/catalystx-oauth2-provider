package TestApp::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => q{});

sub base : Chained('/') PathPart('') CaptureArgs(0) {
    my ( $self, $ctx ) = @_;
    use Data::Dumper;
    warn "LOGGEDIN _REQUIRED";
    warn Dumper $ctx->user_exists;
    warn Dumper $ctx->user;
}

sub test : Chained('base') PathPart('') Args(0) {
    my ( $self, $ctx ) = @_;
    # use Data::Dumper;
    # die Dumper($ctx->view('HTML')->include_path);
}

=head2 logout
=cut
sub logout : Local {
    my ( $self, $ctx ) = @_;
    $ctx->logout();
    $ctx->res->redirect(q{/});
}


=head2 end
Attempt to render a view, if needed.
=cut

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;
    return 1 if $c->res->body;
}


__PACKAGE__->meta->make_immutable;

