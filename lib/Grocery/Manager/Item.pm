package Grocery::Manager::Item;
use base qw( Rose::DB::Object::Manager );

sub object_class { 'Grocery::Item' }

__PACKAGE__->make_manager_methods('items');

1;
