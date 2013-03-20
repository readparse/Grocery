#!/usr/bin/perl -w
use strict;
use Test::More;
use Data::Dumper;
use lib 'lib';

use_ok( 'Grocery::Item' );

my $item = Grocery::Item->new( name => 'hey you test suite 1');
ok($item->save, 'Saved the item');
ok($item->delete, 'Deleted the item');

$item = Grocery::Item->new( name => 'hey you test suite 2');
ok($item->save, 'Saved the second item');

my $item2 = Grocery::Item->new( name => 'hey you test suite 2');
ok($item2->load, 'Loaded item based on name');
ok($item2->delete, 'Deleted second item');



done_testing();

