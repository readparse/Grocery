package Grocery::List;
use base qw( Grocery::DB::Object );
use POSIX qw( ceil );

__PACKAGE__->meta->setup(
	table => 'list',
	columns => [ qw( id name ) ],
	pk_columns => 'id',
	unique_key => 'name',

	relationships => [

		items => {
			type => 'many to many',
			map_class => 'Grocery::ListItem',
			map_from => 'list',
			map_to => 'item',
		}

	]
);



1;
