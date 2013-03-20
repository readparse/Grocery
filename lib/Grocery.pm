package Grocery;
use Grocery::List;
use Grocery::Item;
use Grocery::Status;
use Grocery::ListItem;
use Grocery::Manager::Item;
use Grocery::Manager::List;
use Grocery::Manager::Status;
use Data::Dumper;

use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/list/new' => sub {
	template 'list_form'
};

get '/list/edit/:id' => sub {
	my $id = params->{id};
	my $list = Grocery::List->new( id => $id );
	$list->load;
	template 'list_form', { list => $list };
};

post '/list/save' => sub {
	my $id = params->{list_id};
	my $name = params->{name};
	my $list;
	if ($id) {
		$list = Grocery::List->new( id => $id );
		if ($list->load) {
			$list->name($name);
			$list->save;
		}
	} else {
		$list = Grocery::List->new( name => $name );
		$list->save;
	}
	my $list_id = $list->id;
	redirect "list/$list_id";
};

get '/list/:id' => sub {
	my $id = params->{id};
	my $list = Grocery::List->new( id => $id );
	if ($list->load(speculative => 1)) {
		template 'list', { list => $list }
	} else {
		template 'no_list', { id => $id }
	}
};

post '/item/save' => sub {
	my $id = params->{item_id};
	my $list_id = params->{list_id};
	my $name = params->{name};
	my $items = Grocery::Manager::Item->get_items( query => [  name => $name  ] );
	if (scalar @{$items} > 0) {
		redirect "/list/$list_id?error=uniq";
	} else {
		my $item = Grocery::Item->new( id => $id );
		$item->load;
		$item->name( $name );
		$item->save;
		redirect "/list/$list_id";
	}
};

post '/item/create' => sub {
	my $list_id = params->{list_id};
	if (my $name = params->{item}) {
		my $list = Grocery::List->new( id => $list_id );
		if ($list->load) {
			$list->add_items( { name => $name });
			$list->save;
		}
	}
	redirect "/list/$list_id";
};

get '/item/edit/:id' => sub {
	my $id = params->{id};
	my $item = Grocery::Item->new( id => $id );
	$item->load;
	my $data = { item => $item };
	if (my $list_id = params->{list_id}) {
		my $list = Grocery::List->new( id => $list_id );
		$list->load;
		$data->{list} = $list;
	}
	template 'item_form', $data;
};

true;
