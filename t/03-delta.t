use strict;
use warnings;
use Test::More qw/no_plan/;

use Integer::Elias::Encoder;
use Integer::Elias::Decoder;

my $encoder = Integer::Elias::Encoder->new;

$encoder->delta_encode(0);
$encoder->delta_encode(5);
$encoder->delta_encode(30000000);
$encoder->delta_encode(10);
$encoder->delta_encode(256);
$encoder->finish;

my $decoder = Integer::Elias::Decoder->new( $encoder->binary );

is $decoder->delta_decode, 0;
is $decoder->delta_decode, 5;
is $decoder->delta_decode, 30000000;
is $decoder->delta_decode, 10;
is $decoder->delta_decode, 256;
is $decoder->delta_decode, undef;

## Tests for the binary representation
$encoder = Integer::Elias::Encoder->new;
$encoder->delta_encode(5);
$encoder->finish;

is $encoder->as_string, '01110000';

$encoder = Integer::Elias::Encoder->new;
$encoder->delta_encode(9);
$encoder->finish;

is $encoder->as_string, '0010001000000000';

