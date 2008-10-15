package Integer::Elias::Encoder;
use strict;
use warnings;
use base qw/Integer::Elias/;

use POSIX qw/ceil/;

sub alpha_encode {
    my ($self, $value) = @_;
    for (my $i = 0; $i < $value; $i++) {
        $self->putbit(0);
    }
    $self->putbit(1);
}

sub gamma_encode {
    my ($self, $n) = @_;
    my $nbits = ceil( log($n + 2) / log(2) );
    $self->alpha_encode($nbits - 1);
    $self->putbits($nbits - 1, $n + 1);
}

sub delta_encode {
    my ($self, $n) = @_;
    my $nbits = ceil( log($n + 2) / log(2) );
    $self->gamma_encode($nbits - 1);
    $self->putbits($nbits - 1, $n + 1);
}

1;
