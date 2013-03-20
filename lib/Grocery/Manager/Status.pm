package Grocery::Manager::Status;
use base qw( Rose::DB::Object::Manager );

sub object_class { 'Grocery::Status' }

__PACKAGE__->make_manager_methods('statuses');

1;
