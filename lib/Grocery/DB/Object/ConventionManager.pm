package Grocery::DB::Object::ConventionManager;
use base qw( Rose::DB::Object::ConventionManager );

sub auto_manager_class_name {
	my $class = shift;
	$class =~ s/::(\w+)$/::Manager::$1/;
	return $class;
}

1;
