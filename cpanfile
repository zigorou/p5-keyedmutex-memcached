requires 'Scope::Guard', '0.2';
requires 'Time::HiRes';

on build => sub {
    requires 'ExtUtils::MakeMaker', '6.36';
};

on test => sub {
    requires 'Cache::Memcached::Fast';
    requires 'File::Which';
    requires 'Proc::Guard';
    requires 'Test::More';
    requires 'Test::Skip::UnlessExistsExecutable';
    requires 'Test::TCP';
};
