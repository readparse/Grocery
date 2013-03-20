PRAGMA foreign_keys=ON;

drop table list_item;
drop table item;
drop table list;
drop table status;

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

create table list_item(
	id integer primary key autoincrement,
	list_id integer references list(id) on delete cascade,
	item_id integer references item(id) on delete cascade,
	sequence integer,
	status_id integer references status(id) on delete set null
);


