use FindBin;
use lib "$FindBin::Bin/../../lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub::Repos::Downloads');
}

my $obj = Pithub::Test->create( 'Pithub::Repos::Downloads', user => 'foo', repo => 'bar' );

isa_ok $obj, 'Pithub::Repos::Downloads';

throws_ok { $obj->create } qr{not supported}, 'Not supported yet';

done_testing;
