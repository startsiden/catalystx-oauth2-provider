package Catalyst::ActionRole::ProtectedResource;
use Moose::Role;
use namespace::autoclean;


before 'execute' => sub {
  my ( $self, $controller, $ctx, $test ) = @_;
  my $authorization =  $ctx->req->header('authorization');
  $authorization    =~ m{MAC\s+(?<token>token=['||"][\w+\d+]+['|"]),
                               (?<timestamp>timestamp=['||"][\w+\d+]+['|"]),
                               (?<nonce>nonce=['||"][\w+\d+]+['|"]),
                               (?<signature>signature=['||"][\w+\d+=]+['|"])}xs;
  my ( $token, $timestamp, $nonce, $signature );
  eval "\$$+{token};\$$+{timestamp};\$$+{nonce};\$$+{signature}";
  $ctx->stash->{auth}->{token}     = $token;
  $ctx->stash->{auth}->{timestamp} = $timestamp;
  $ctx->stash->{auth}->{nonce}     = $nonce;
  $ctx->stash->{auth}->{signature} = $signature;
};

around execute => sub {
    my $orig  = shift;
    my $self  = shift;
    my ( $controller, $ctx, @args ) = @_;

    if ( ! $ctx->user 
         or !( $ctx->user->{token} eq $ctx->stash->{auth}->{token} ) ) {
        CatalystX::OAuth2::Provider::Error::InvalidToken->throw( description => 'Invalide token' );
        $ctx->detach;
    } else {
        return $self->$orig(@_);
    }
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

