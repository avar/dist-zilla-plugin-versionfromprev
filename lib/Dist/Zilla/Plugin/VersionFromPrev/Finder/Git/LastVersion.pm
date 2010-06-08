package Dist::Zilla::Plugin::VersionFromPrev::Finder::Git::LastVersion;

use 5.010;
use Moose;

sub last_version {
    chomp(my @tags = qx[ git tag -l ]);
    my @sorted = sort { $b <=> $a } @tags;
    my $last = $sorted[0];

    return $last eq '' ? undef : $last;
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Dist::Zilla::Plugin::Git::LastVersion - Get the last version via Git tag with C< git tag -l | sort -nr | head -n1 >

=head1 AUTHOR

E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

This program is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
