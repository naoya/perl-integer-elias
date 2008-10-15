use inc::Module::Install;

perl_version '5.8.1';
name 'Integer-Elias';

all_from 'lib/Integer/Elias.pm';

requires 'perl' => '5.8.1';
requires 'Class::Accessor::Lvalue::Fast';
requires 'Params::Validate';

auto_install;

WriteAll;
