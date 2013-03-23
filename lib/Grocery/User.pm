package Grocery::User;
use base qw( Grocery::DB::Object );
use POSIX qw( ceil );
use Crypt::SaltedHash;

__PACKAGE__->meta->setup(
	table => 'user',
	columns => [ 
		id => { type => 'integer', not_null => 1 }, 
		email => { type => 'varchar', length => 255, not_null => 1},
		password => { type => 'varchar', length => 255, not_null => 1}, 
		created => { type => 'timestamp', default => 'now' }, 
		lastlogin => { type => 'timestamp'} 
	 ],
	pk_columns => 'id',
	unique_key => 'email',
);

sub email_available {
	my $this = shift;
	if ($this->email) {
		if (Grocery::User->new( email => $this->email )->load( speculative => 1 )) {
			return 0;
		}
	}
	return 1;
}

sub save {
	my $self = shift;
	if (my $password = $self->password) {
		unless ($password =~ /^\{SSHA1\}/) {
			my $dsh = Crypt::SaltedHash->new( algorithm => 'SHA1' );
			$dsh->add($password);
			my $salted = $dsh->generate;
			$self->password($salted);
		}
	}
	$self->SUPER::save(@_);
}

sub authenticate {
	my ($self, $password) = @_;
	return Crypt::SaltedHash->validate($self->password, $password);
}

1;
