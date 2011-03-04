package CatalystX::OAuth2::Provider::Controller::OAuth;
use Moose;
use Moose::Autobox;
use MooseX::Types::Moose qw/ HashRef ArrayRef ClassName Object Str /;
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;
use JSON::XS ();
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole'; }

with qw(
    CatalystX::Component::Traits
    Catalyst::Component::ContextClosure
);


BEGIN { extends 'Catalyst::Controller::ActionRole'; }

with 'CatalystX::Component::Traits';

has '+_trait_merge' => ( default => 1 );

__PACKAGE__->config( traits => [qw/AuthorizationCode/] );

=head2 base
=cut
sub base :Chained('/') :PathPart('oauth') :CaptureArgs(0) { }

=head2 logged_in_required
=cut
sub logged_in_required
    :Chained('base')
    :PathPart('')
    :CaptureArgs(0)
{
    my ( $self, $ctx ) = @_;
    $ctx->forward( 'user_existed_or_authenticated' ); #CHECK USER
}

=head2 user_existed_or_authenticated
=cut
sub user_existed_or_authenticated
    :Private 
{
    my ( $self, $ctx ) = @_;
    return 1 if $ctx->user_exists();
    return 1 if $ctx->authenticate(
                  { username => $ctx->req->param('username')
                                || $ctx->req->param($self->{login_form}->{field_names}->{username}), 
                    password => $ctx->req->param('password')
                                || $ctx->req->param($self->{login_form}->{field_names}->{password}),
                  } );

    $ctx->stash( template => $self->{login_form}->{template} 
                              || 'user/login.tt' );
    $ctx->res->status( 403 );
    $ctx->detach();
}

=head2 logged_in_not_required
=cut
sub logged_in_not_required
    :Chained('base')
    :PathPart('')
    :CaptureArgs(0)
{}

=head2 token
=cut
sub token
    :Chained('logged_in_not_required')
    :PathPart('token')  #Configurable?
    :Args(0)
{
    my ( $self, $ctx ) = @_;
    ### LOGIC ###
      #Get the client grant_type param
      #Forward to GrantHandler
      #GrantHandler decides what to do by a recieved grant_type
          # *** In certain type of grant_type will interact with Model ***
      #IF a valid client
      #Reponse access_token as key in JSON format to client
      
    my %test_data = ( "access_token"  =>  "04u7h-4cc355-70k3n",
                      "expires_in"    =>   3600,
                      "scope"         =>   undef,
                      "refresh_token" => "04u7h-r3fr35h-70k3n" ); #testing
    $ctx->res->body( JSON::XS->new->pretty(1)->encode(\%test_data) );
}

=head2 authorize
=cut
sub authorize
    :Chained('logged_in_required')
    :PathPart('authorize') #Configurable?
    :Args(0)
{
    my ( $self, $ctx ) = @_;
    ### LOGIC ###
    # Verify client from $ctx->req
    # IF NOT a valid client
        #THEN Throw an error says invalid_client
    # IF a valid client
        #THEN 
           #load client information
           #generate code and access_token
           #REDIRECT back to client_callback_uri + code

    if ( $ctx->req->method eq 'GET' ) {
       $ctx->stash( authorize_endpoint => $ctx->uri_for_action($ctx->action) );
       $ctx->stash( template => 'oauth/authorize.tt' ); 
    }

    if ( $ctx->req->method eq 'POST' ) {

        my $uri  = $ctx->uri_for( $ctx->req->param("redirect_uri"),
                                      { code         => q{code_bar},
                                        redirect_uri => $ctx->req->param("redirect_uri"),  
                                      } );
        $uri     =~ m,/(?<http>http://)(?<url>[\w\d:#@%/;$()~_?\+-=\\\.&]*),; #to external URI
        $ctx->res->redirect( $+{http} . $+{url} );
    }
    $ctx->detach();
}


=pod
=cut