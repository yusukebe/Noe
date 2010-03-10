use inc::Module::Install;
name 'Noe';
all_from 'lib/Noe.pm';

# requires '';

install_script 'bin/noe-server';

tests 't/*.t';
#author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
