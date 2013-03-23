package Grocery;
use Grocery::List;
use Grocery::Item;
use Grocery::Status;
use Grocery::ListItem;
use Grocery::User;
use Grocery::Manager::Item;
use Grocery::Manager::List;
use Grocery::Manager::Status;
use Grocery::Manager::ListItem;
use Crypt::SaltedHash;
use Data::Dumper;

use Dancer ':syntax';

our $VERSION = '0.1';

hook before_template => sub {
	my $hash = shift;
	if (my $user = session('user')) {
		$hash->{user} = $user;
	}
};

get '/' => sub {
    redirect '/lists';
};

get '/login' => sub {
	template 'login_form'
};

post '/login' => sub {
	my $email = params->{email};
	my $password = params->{password};
	my $user = Grocery::User->new( email => $email );
	if ($user->load( speculative => 1 ) ) {
		if (my $token = $user->authenticate($password)) {
			session user => {
				id => $user->id,
				email => $user->email,
				token => $user->token,
			};
			redirect '/';
		} else {
			return "password is incorrect";
		}
	} else {
		return "this user does not exist";
	}
};

get '/logout' => sub {
	session->destroy;
	redirect request->referer;
};

get '/lists' => sub {
	my $lists = Grocery::Manager::List->get_lists();
	template 'lists', { lists => $lists }
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

get '/list/delete/:id' => sub {
	my $id = params->{id};
	my $list = Grocery::List->new( id => $id );
	$list->delete;
	redirect '/lists'
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
		if ($list->load( speculative => 1 )) {
			return template 'list_exists', { list => $list };
		} else {
			$list->save;
		}
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

get '/item/delete/:id' => sub {
	my $item_id = params->{id};
	my $item = Grocery::Item->new( id => $item_id );
	$item->delete;
	redirect "/lists";	
};

post '/item/add_to_list' => sub {
	my $list_id = params->{list_id};
	if (my $name = params->{item}) {
		my $list = Grocery::List->new( id => $list_id );
		my $item = Grocery::Item->new( name => $name );
		if ($list->load) {
			if ($item->load( speculative => 1 )) {
				if ($list->can_add_item( $item )) {
					$list->add_items( $item );
				}
			} else {
				$list->add_items( { name => $name });
			}
			$list->save;
			$list->set_blank_item_status( config->{default_status} );
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

get '/item/:item_id/list/remove/:list_id' => sub {
	my $item_id = params->{item_id};
	my $list_id = params->{list_id};
	my $list_items = Grocery::Manager::ListItem->get_list_items( query => [ list_id => $list_id, item_id => $item_id ]);
	if (my $list_item = shift @{$list_items}) {
		$list_item->delete;
	}
	redirect "/list/$list_id";
};

true;
