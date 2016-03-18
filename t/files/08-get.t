use Test::Most;
use Test::Mock::Furl;
use Furl::Response;
use_ok('Google::Client');

use Path::Tiny;
my $content = path('./t/files/file-resource-object.json')->slurp;

ok my $client = Google::Client->new(
    access_token => 'bogey access token'
), 'ok built client';

{
    $Mock_furl->mock(
        request => sub {
            return Furl::Response->new(1, 200, 'OK', {'content-type' => 'application/json'}, $content);
        }
    );

    $Mock_furl_res->mock(
        decoded_content => sub { return $content; }
    );

    ok my $json = $client->files->get(8), 'can request to get file by fileId';
    ok $json->{id}, "can read as json";
}
done_testing;
