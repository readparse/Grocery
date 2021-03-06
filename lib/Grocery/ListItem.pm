package Grocery::ListItem;
use base qw( Grocery::DB::Object );
use POSIX qw( ceil );

__PACKAGE__->meta->setup(
	table => 'list_item',
	columns => [ qw( id list_id item_id sequence status_id) ],
	pk_columns => 'id',
	unique_key => [ list_id, item_id ],

	foreign_keys => [
		list => {
			class => 'Grocery::List',
			key_columns => {list_id => 'id'}
		},
		item => {
			class => 'Grocery::Item',
			key_columns => {item_id => 'id'}
		},
		status => {
			class => 'Grocery::Status',
			key_columns => {status_id => 'id'}
		},
	],

);



1;
