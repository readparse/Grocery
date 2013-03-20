package Grocery::DB::Object;
use Grocery::DB;
use Rose::DB::Object;
use Grocery::DB::Object::Metadata;
use base qw( Rose::DB::Object );

sub init_db { 
	my $db = Grocery::DB->new;
	$db->dbh->do("PRAGMA foreign_keys = ON");
	return $db;
}

sub meta_class { 'Grocery::DB::Object::Metadata' }

sub values {
	my $this = shift;
	my $out = {};
	for my $column($this->meta->columns) {
		$out->{$column} = $this->$column;
	}
	return $out;
}


1;
