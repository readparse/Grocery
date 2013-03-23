PRAGMA foreign_keys=ON;

drop table list_item;
drop table item;
drop table list;
drop table status;
drop table user;

create table user(
	id integer primary key autoincrement,
	email varchar(255) unique,
	password varchar(255),
	token varchar(255),
	created datetime default(current_timestamp),
	lastlogin datetime
);

create table list(
	id integer primary key autoincrement,
	name varchar(255) unique
);

create table item(
	id integer primary key autoincrement,
	name varchar(255) unique
);

create table status(
	id integer primary key autoincrement,
	name varchar(255) unique
);

insert into status (name) values('Pending');
insert into status (name) values('Priced');
insert into status (name) values('Purchased');

create table list_item(
	id integer primary key autoincrement,
	list_id integer references list(id) on delete cascade,
	item_id integer references item(id) on delete cascade,
	sequence integer,
	status_id integer references status(id) on delete set null,
	constraint uniq_list_item unique (list_id, item_id)
);


