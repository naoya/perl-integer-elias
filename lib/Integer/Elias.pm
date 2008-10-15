package Integer::Elias;
use strict;
use warnings;
use base qw/Class::Accessor::Lvalue::Fast/;

our $VERSION = '0.01';

__PACKAGE__->mk_accessors(qw/buff binary count/);

sub new {
    my ($class, $data) = @_;
    my $self = $class->SUPER::new;

    $self->count  = defined $data ? 0 : 8;
    $self->binary = defined $data ? $data : '';
    $self->buff   = 0;

    bless $self, $class;
}

sub finish {
    my $self = shift;
    $self->putc($self->buff);
    return $self->binary;
}

sub putc {
    my ($self, $c) = @_;
    $self->binary = join '', $self->binary, pack('C', $c);
}

sub getc {
    my $self = shift;
    my $c = unpack('C', $self->binary);
    substr($self->binary, 0, 1) = '';
    return $c;
}

sub getbit {
    my $self = shift;
    $self->count--;

    if ($self->count < 0) {
        $self->buff = $self->getc;
        if (not defined $self->buff) {
            return;
        }
        $self->count = 7;
    }

    return ($self->buff >> $self->count) & 0x01;
}

sub getbits {
    my ($self, $n) = @_;

    my $v = 0;
    my $p = 1 << ($n - 1);

    while ($p > 0) {
        my $bit = $self->getbit;
        if (not defined $bit) {
            return $v;
        }

        if ($bit == 1) {
            $v |= $p;
        }

        $p >>= 1;
    }

    return $v;
}

sub putbit {
    my ($self, $bit) = @_;
    $self->count--;

    if ($bit > 0) {
        $self->buff |= (1 << $self->count);
    }

    if ($self->count == 0) {
        $self->putc($self->buff);
        $self->buff = 0;
        $self->count = 8;
    }

    return $bit;
}

sub putbits {
    my ($self, $n, $value) = @_;
    if ($n > 0) {
        my $p = 1 << ($n - 1);
        while ($p > 0) {
            $self->putbit( $value & $p );
            $p >>= 1;
        }
    }
}

sub as_string {
    unpack('B*', shift->binary);
}

1;

__END__

=head1 NAME

Integer::Elias - Elias coder

=head1 SYNOPSIS

  use Integer::Elias::Encoder;
  use Integer::Elias::Decoder;

  ## Gamma code
  my $encoder = Integer::Elias::Encoder->new;
  $encoder->gamma_encode(0); ## this module can encode 0
  $encoder->gamma_encode(5);
  $encoder->gamma_encode(10);
  $encoder->finish;

  say $encoder->as_string;

  my $decoder = Integer::Elias::Decoder->new( $encoder->binary );
  $decoder->gamma_decode; # 0
  $decoder->gamma_decode; # 5
  $decoder->gamma_decode; # 10

  ## Delta code
  $encoder = Integer::Elias::Encoder->new;
  $encoder->delta_encode(10);
  ...
  $encoder->finish;

  say $encoder->as_string;

  $decoder = Integer::Elias::Decoder->new( $encoder->binary );
  $decoder->delta_decode;
  ...

=head1 DESCRIPTION

Elias gamma/delta code is a universal code encoding positive integers.

=head1 SEE ALSO

L<http://en.wikipedia.org/wiki/Universal_code_(data_compression)>
L<http://www.geocities.jp/m_hiroi/light/pyalgo30.html>

=head1 AUTHOR

Naoya Ito, E<lt>naoya at bloghackers.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Naoya Ito

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
