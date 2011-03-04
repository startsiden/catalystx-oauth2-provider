package TestApp;
use Moose;
use namespace::autoclean;

use Catalyst qw/
    +CatalystX::OAuth2::Provider
    Authentication
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    Session::PerUser
/;
extends 'Catalyst';

__PACKAGE__->config(home => undef, root => undef);
__PACKAGE__->config(
    'Plugin::Authentication' => {
        default => {
            credential => {
                class => 'Password',
                password_field => 'password',
                password_type => 'clear'
            },
            store => {
                class => 'Minimal',
                users => {
                    di => {
                        password => "r0ck3r",
                    },
                },
            },
        },
    },
);

__PACKAGE__->config(
    'Controller::OAuth' => {
        login_form => {
           template => 'user/login.tt',
           field_names => {
               username => 'mail',
               password => 'userPassword'
           }
        },
    }, 
    'Authorization::Handler' => undef
);

__PACKAGE__->setup;

1;
