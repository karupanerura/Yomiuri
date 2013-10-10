package Yomiuri::Web;
use strict;
use warnings;
use utf8;

use parent qw/Yomiuri Amon2::Web/;

use Yomiuri::Web::C;

use File::Spec;
use Yomiuri::Utils ();

# dispatcher
use Yomiuri::Web::Dispatcher;
sub dispatch {
    return (Yomiuri::Web::Dispatcher->dispatch($_[0]) or die "response is not generated");
}

# setup view
sub create_view { shift->view }

sub psgi_path { File::Spec->catfile(Yomiuri::Utils::search_project_dir(), '.yomiuri', 'app.psgi') }

# load plugins
__PACKAGE__->load_plugins(
    'Web::FillInFormLite',
    'Web::CSRFDefender' => +{
        post_only => 1,
    },
);

# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;

        # http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx
        $res->header( 'X-Content-Type-Options' => 'nosniff' );

        # http://blog.mozilla.com/security/2010/09/08/x-frame-options/
        $res->header( 'X-Frame-Options' => 'DENY' );

        # Cache control.
        $res->header( 'Cache-Control' => 'private' );
    },
);


1;
__END__
