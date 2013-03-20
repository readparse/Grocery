#!/usr/bin/perl -w
use strict;
use Test::More;
use Data::Dumper;
use lib 'lib';



use_ok( 'Grocery::List' );

my $list = Grocery::List->new( name => 'hey you test suite 1');
ok($list->save, 'Saved the list');
ok($list->delete, 'Deleted the list');

$list = Grocery::List->new( name => 'hey you test suite 2');
ok($list->save, 'Saved the second list');


ok(my $milk = Grocery::Item->new( name => 'Milk' )->save, 'Created Milk');
ok(my $grapes = Grocery::Item->new( name => 'Grapes' )->save, 'Created Grapes');
ok(my $bread = Grocery::Item->new( name => 'Bread' )->save, 'Created Bread');

$list->add_items( $milk, $grapes, $bread );

ok($list->save, 'Saved list');


my $list2 = Grocery::List->new( name => 'hey you test suite 2');
ok($list2->load, 'Loaded list based on name');
ok($list2->delete, 'Deleted second list');

ok($milk->delete, 'Deleted milk');
ok($grapes->delete, 'Deleted grapes');
ok($bread->delete, 'Deleted bread');

done_testing();

