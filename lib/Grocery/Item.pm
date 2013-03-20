package Grocery::Item;
use base qw( Grocery::DB::Object );
use POSIX qw( ceil );

__PACKAGE__->meta->setup(
	table => 'item',
	columns => [ qw( id name ) ],
	pk_columns => 'id',
	unique_key => 'name',

	relationships => [
	
		lists => {
			type => 'many to many',
			map_class => 'Grocery::ListItem',
			map_from => 'item',
			map_to => 'list',
		}
	]

);



1;
