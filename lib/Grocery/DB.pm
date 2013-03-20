package Grocery::DB;
use base 'Rose::DB';

__PACKAGE__->use_private_registry;

__PACKAGE__->register_db(
  driver => 'sqlite',
  database => 'grocery.db',
);

