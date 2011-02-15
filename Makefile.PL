use inc::Module::Install;
name 'KeyedMutex-Memcached';
all_from 'lib/KeyedMutex/Memcached.pm';

requires 'Scope::Guard', 0.20;
requires 'Time::HiRes';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'Test::TCP';
test_requires 'Test::Skip::UnlessExistsExecutable';

test_requires 'Cache::Memcached::Fast';
test_requires 'File::Which';
test_requires 'Proc::Guard';

auto_set_repository;
auto_include;
WriteAll;
