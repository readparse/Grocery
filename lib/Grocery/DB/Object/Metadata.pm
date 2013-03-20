package Grocery::DB::Object::Metadata;
use Grocery::DB::Object::ConventionManager;
use base qw( Rose::DB::Object::Metadata );

sub convention_manager_class { 'Grocery::DB::Object::ConventionManager' }

1;
