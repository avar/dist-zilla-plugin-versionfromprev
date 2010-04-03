package Dist::Zilla::Plugin::VersionFromPrev::Style::Classic;

use 5.010;
use Moose;

sub bump {
    my ($self, $parent, $now) = @_;

    given ($now) {
        when (not defined $now) { return '0.01' }
        when (/^ (?<major_version>\d+) \. (?<minor_version>\d+) (?:_(?<dev_version>\d+))? $/x) {
            return $now if $ENV{DONT_BUMP_VERSION};
            
            die "I don't handle dev versions yet" if $+{dev_version};
            
            # Bump +1
            if ($+{minor_version} == 99) {
                my ($major, $minor) = ($+{major_version} + 1, 0);
                return sprintf "%d.%02d", $major, $minor;
            } else {
                my ($major, $minor) = ($+{major_version}, $+{minor_version} + 1);
                return sprintf "%d.%02d", $major, $minor;
            }
            
        }
        default { die "WTF @ '$_'" }
    }
}

__PACKAGE__->meta->make_immutable;
