package Catalyst::ActionRole::ProtectedResource;
use Moose::Role;
use HTTP::Headers::Util qw(split_header_words);
use namespace::autoclean;

around execute => sub {
    my $orig  = shift;
    my $self  = shift;
    my ( $controller, $ctx, @args ) = @_;

    my @values = split_header_words( $ctx->request->header('authorization') );
    my $token  = $values[0][-1];

    # $ctx->log->debug("AUTH TOKEN: $token, USER TOKEN: " . $ctx->user->{token}) if $ctx->debug;

    if ( ! $ctx->user or !( $ctx->user->{token} eq $token ) ) {
        $ctx->stash( error => "invalid_request",
                     error_description => "Wrong token" );

    }
    return $self->$orig(@_);
};

1;

__END__

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 WRAPPED METHODS


=head1 SEE ALSO

=head1 AUTHORS

=head1 LICENSE

=cut

