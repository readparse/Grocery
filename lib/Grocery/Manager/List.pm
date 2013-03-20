package Grocery::Manager::List;
use base qw( Rose::DB::Object::Manager );

sub object_class { 'Grocery::List' }

__PACKAGE__->make_manager_methods('lists');

1;
