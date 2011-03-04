package CatalystX::OAuth2::Provider;
use Moose::Role;
use CatalystX::InjectComponent;
use namespace::autoclean;

our $VERSION = '0.0001';

after 'setup_components' => sub {
    my $class = shift;
    CatalystX::InjectComponent->inject(
        into      => $class,
        component => 'CatalystX::OAuth2::Provider::Controller::OAuth',
        as        => 'Controller::OAuth',
    );
    
    # CatalystX::InjectComponent->inject(
    #     into      => $class,
    #     component => 'CatalystX::OAuth2::Provider::Authorization::Handler',
    #     as        => 'Authorization::Handler',
    # );

};


=head1 NAME

CatalystX::OAuth2::Provider - 

=head1 DESCRIPTION

=head1 METHODS

=head1 BUGS

=head1 AUTHOR

=head1 COPYRIGHT & LICENSE

Copyright 2009 the above author(s).

This sofware is free software, and is licensed under the same terms as perl itself.

=cut

1;
