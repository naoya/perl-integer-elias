use strict;
use warnings;
use Test::More qw/no_plan/;

use Integer::Elias::Encoder;
use Integer::Elias::Decoder;

my $encoder = Integer::Elias::Encoder->new;

$encoder->gamma_encode(0);
$encoder->gamma_encode(5);
$encoder->gamma_encode(30000000);
$encoder->gamma_encode(10);
$encoder->gamma_encode(256);
$encoder->finish;

my $decoder = Integer::Elias::Decoder->new( $encoder->binary );

is $decoder->gamma_decode, 0;
is $decoder->gamma_decode, 5;
is $decoder->gamma_decode, 30000000;
is $decoder->gamma_decode, 10;
is $decoder->gamma_decode, 256;
is $decoder->gamma_decode, undef;

## Tests for the binary representation
$encoder = Integer::Elias::Encoder->new;
$encoder->gamma_encode(5);
$encoder->finish;

is $encoder->as_string, '00110000';

$encoder = Integer::Elias::Encoder->new;
$encoder->gamma_encode(9);
$encoder->finish;

is $encoder->as_string, '00010100';
