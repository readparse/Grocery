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

sub can_add_item {
	my $this = shift;
	my $item = shift;
	for my $i($this->items) {
		if ($item->id == $i->id) {
			return 0;
		}
	}
	return 1;
}

1;
