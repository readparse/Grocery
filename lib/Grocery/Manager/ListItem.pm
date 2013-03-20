package Grocery::Manager::ListItem;
use base qw( Rose::DB::Object::Manager );

sub object_class { 'Grocery::ListItem' }

__PACKAGE__->make_manager_methods('list_items');

1;
