use strict;
use warnings;
use Test::More qw/no_plan/;

use Integer::Elias::Encoder;
use Integer::Elias::Decoder;

my $encoder = Integer::Elias::Encoder->new;

$encoder->alpha_encode(0);
$encoder->alpha_encode(5);
$encoder->alpha_encode(10);
$encoder->alpha_encode(256);
$encoder->finish;

my $decoder = Integer::Elias::Decoder->new( $encoder->binary );

is $decoder->alpha_decode, 0;
is $decoder->alpha_decode, 5;
is $decoder->alpha_decode, 10;
is $decoder->alpha_decode, 256;
is $decoder->alpha_decode, undef;


## Tests for the binary representation
$encoder = Integer::Elias::Encoder->new;
$encoder->alpha_encode(5);
$encoder->finish;

is $encoder->as_string, '00000100';

$encoder = Integer::Elias::Encoder->new;
$encoder->alpha_encode(9);
$encoder->finish;

is $encoder->as_string, join('', '00000000', '01000000');
