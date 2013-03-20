package Grocery::Status;
use base qw( Grocery::DB::Object );
use POSIX qw( ceil );

__PACKAGE__->meta->setup(
	table => 'status',
	columns => [ qw( id name ) ],
	pk_columns => 'id',
	unique_key => 'name',

);



1;
