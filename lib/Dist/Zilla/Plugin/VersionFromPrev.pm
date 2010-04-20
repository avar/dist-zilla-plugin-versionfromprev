package Dist::Zilla::Plugin::VersionFromPrev;

use 5.010;
use Moose;

with 'Dist::Zilla::Role::VersionProvider';

has version_style => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => 'Classic',
);

has version_finder => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => 'Git::LastVersion',
);

sub provide_version {
    my ($self) = @_;

    my $version_style        = $self->version_style;
    my $version_style_class  = "Dist::Zilla::Plugin::VersionFromPrev::Style::$version_style";
    Class::MOP::load_class($version_style_class);
    my $version_style_obj    = $version_style_class->new;

    my $version_finder        = $self->version_finder;
    my $version_finder_class  = "Dist::Zilla::Plugin::VersionFromPrev::Finder::$version_finder";
    Class::MOP::load_class($version_finder_class);
    my $version_finder_obj    = $version_finder_class->new;

    my $last_version = $version_finder_obj->last_version($self);

    return $ENV{BUMP_VERSION_TO} // $version_style_obj->bump($self, $last_version);
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Dist::Zilla::Plugin::VersionFromPrev - Bump your version internally for use at release time

=head1 DESCRIPTION

This plugin was written because the author didn't like the time-based
version RJBS likes to use as implemented in
L<Dist::Zilla::Plugin::AutoVersion>. Instead this plugin supports the
classic CPAN version schema where you start at C<0.01> and move
towards C<0.99>, then increment to C<1.00> and keep going from there.

This is how you use the plugin:

    [VersionFromPrev]

or more verbosely:

    [VersionFromPrev]
    version_style = Classic
    version_finder = Git::LastVersion

For this to work you have to save your version somewhere persistently
like in Git using L<Dist::Zilla::Plugin::Git::Tag>. What'll then
happen is that:

=over

=item *

When L<Dist::Zilla> starts up we'll find the existing version using
L<*::Git::LastVersion|Dist::Zilla::Plugin::VersionFromPrev::Finder::Git::LastVersion>.

=item *

We'll bump the version internally using
e.g. L<*::Classic|Dist::Zilla::Plugin::VersionFromPrev::Style::Classic>.

=item *

You have to use L<Dist::Zilla::Plugin::Git::Tag> so or manually set a
new Git tag on release so that
L<*::Git::LastVersion|Dist::Zilla::Plugin::VersionFromPrev::Finder::Git::LastVersion>
can find in the next time you run C<dzil release>.

=back

If you don't like the defaults then you can write your own version
provider plugin and make it use that by supplying another
C<version_style> and C<version_finder> in the
C<Dist::Zilla::Plugin::VersionFromPrev::Style> and
L<Dist::Zilla::Plugin::VersionFromPrev::Finder> namespaces.

=head1 ATTRIBUTES

=head2 version_style

The short name of the version style plugin you want to
use. L<"Classic"|Dist::Zilla::Plugin::VersionFromPrev::Style::Classic>
by default.

=head2 version_provider

The short name of the version provider plugin you want to
use. L<"Git::LastVersion"|Dist::Zilla::Plugin::VersionFromPrev::Finder::Git::LastVersion>.
by default.

=head1 Environment

This module understands the following environmental variables:

=over

=item * C<DONT_BUMP_VERSION>

If set the version won't be bumped at all. Useful for producing a
tarball for your last release.

=item * C<BUMP_VERSION_TO>

Bump the version to a given version,
e.g. C<DONT_BUMP_VERSION=1.00>. Useful if you want to skip a version
or go from e.g. C<0.10> to C<1.00>.

=back

=head1 BUGS

Yes, and probably some that I don't know about. It works for me, if it
doesn't for you fork it on GitHub & patch it & release it.

=head1 AUTHOR

E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

This program is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
