use inc::Module::Install;
name 'Noe';
all_from 'lib/Noe.pm';

requires 'Plack::Request';
requires 'UNIVERSAL::require';
requires 'Template';
requires 'IO::File';
requires 'Path::Class';
requires 'YAML';
requires 'HTTPx::Dispatcher';
requires 'Text::MicroTemplate::Extended';

recommends 'JSON::XS';

install_script 'bin/noe-server';
install_script 'bin/noe-setup';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
