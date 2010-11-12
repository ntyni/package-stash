#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Package::Stash;

{
    package Foo;
    use constant FOO => 1;
    use constant BAR => \1;
    use constant BAZ => [];
    use constant QUUX => {};
    use constant QUUUX => sub { };
    sub normal { }
    sub stub;
    sub normal_with_proto () { }
    sub stub_with_proto ();

    our $SCALAR;
    our $SCALAR_WITH_VALUE = 1;
    our @ARRAY;
    our %HASH;
}

my $stash = Package::Stash->new('Foo');
{ local $TODO = "i think this is a perl bug (see comment in has_package_symbol)";
ok($stash->has_package_symbol('$SCALAR'), '$SCALAR');
}
ok($stash->has_package_symbol('$SCALAR_WITH_VALUE'), '$SCALAR_WITH_VALUE');
ok($stash->has_package_symbol('@ARRAY'), '@ARRAY');
ok($stash->has_package_symbol('%HASH'), '%HASH');
is_deeply(
    [sort $stash->list_all_package_symbols('CODE')],
    [qw(BAR BAZ FOO QUUUX QUUX normal normal_with_proto stub stub_with_proto)],
    "can see all code symbols"
);

$stash->add_package_symbol('%added', {});
ok(!$stash->has_package_symbol('$added'), '$added');
ok(!$stash->has_package_symbol('@added'), '@added');
ok($stash->has_package_symbol('%added'), '%added');

done_testing;