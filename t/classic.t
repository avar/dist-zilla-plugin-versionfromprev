use strict;
use Test::More;
use Dist::Zilla::Plugin::VersionFromPrev::Style::Classic;
use Test::More tests => 7;

my $t = sub { Dist::Zilla::Plugin::VersionFromPrev::Style::Classic::bump({}, {}, shift) };

is($t->(undef), '0.01');
is($t->('0.01'), '0.02');
is($t->('0.09'), '0.10');
is($t->('0.50'), '0.51');
is($t->('0.99'), '1.00');
is($t->('1.00'), '1.01');

local $@;
eval {

    $t->('1.00_01');
};
like($@, qr/don't handle/, "Can't handle _ versions");
