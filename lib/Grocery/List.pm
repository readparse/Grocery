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

sub set_blank_item_status {
	my ($this, $status_name) = @_;
	my $status = Grocery::Status->new( name => $status_name );
	if ($status->load( speculative => 1 ) ) {
		my $items = Grocery::Manager::ListItem->get_list_items( query => [ list_id => $this->id ] );
		for my $item (@{$items}) {
			unless($item->status) {
				$item->status( $status );
				$item->save;
			}
		}
	}
}

1;
