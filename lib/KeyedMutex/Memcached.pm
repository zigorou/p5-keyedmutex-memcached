package KeyedMutex::Memcached;

use strict;
use warnings;
use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/key locked interval trial timeout prefix cache/],
);
use Scope::Guard qw(scope_guard);
use Time::HiRes qw(usleep);

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args = ref $_[0] ? $_[0] : +{@_};
    $args = +{
        interval => 0.01,
        trial    => 0,
        timeout  => 30,
        prefix   => 'km',
        locked   => 0,
        %$args,
    };
    bless $args => $class;
}

sub lock {
    my ( $self, $key, $use_raii ) = @_;

    $key = $self->prefix . ':' . $key if ( $self->prefix );
    $self->key($key);
    $self->locked(0);

    my $i        = 0;
    my $rv       = 0;
    my $interval = $self->interval * 1000;
    while ( $self->trial == 0 || ++$i <= $self->trial ) {
        $rv = $self->cache->add( $key, 1, $self->timeout ) ? 1 : 0;
        if ($rv) {
            $self->locked(1);
            last;
        }
        usleep($interval);
    }

    return $rv ? ( $use_raii ? scope_guard { $self->release } : 1 ) : 0;
}

sub release {
    $_[0]->cache->delete( $_[0]->key );
    1;
}

1;
__END__

=head1 NAME

KeyedMutex::Memcached -

=head1 SYNOPSIS

  use KeyedMutex::Memcached;

  my $key   = 'query:XXXXXX';
  my $cache = Cache::Memcached::Fast->new( ... );
  my $mutex = KeyedMutex::Memcached->new( cache => $cache );

  if ( my $lock = $mutex->lock( $key, 1 ) ) {
    ### do task
  }

=head1 DESCRIPTION

KeyedMutex::Memcached is

=head1 AUTHOR

Toru Yamaguchi E<lt>zigorou@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
