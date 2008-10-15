package Integer::Elias::Decoder;
use strict;
use warnings;
use base qw/Integer::Elias/;

use Params::Validate qw/validate_pos/;

sub new {
    my ($class, $bin) = validate_pos(@_, 1, 1);
    return $class->SUPER::new($bin);
}

sub alpha_decode {
    my $self = shift;

    my $n = 0;
    while (1) {
        my $bit = $self->getbit;

        if (not defined $bit) {
            return;
        } elsif ($bit == 0) {
            $n++;
        } else {
            last;
        }
    }

    return $n;
}

sub gamma_decode {
    my $self = shift;
    my $nbits = $self->alpha_decode;

    if (!$nbits) {
        return $nbits;
    }

    return ((1 << $nbits) + $self->getbits($nbits)) - 1;
}

sub delta_decode {
    my $self = shift;
    my $nbits = $self->gamma_decode;

    if (!$nbits) {
        return $nbits;
    }

    return ((1 << $nbits) + $self->getbits($nbits)) - 1;
}

1;
