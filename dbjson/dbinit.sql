create table restaurant(restaurant_id serial PRIMARY KEY, ta_id integer unique, name VARCHAR (150) NOT NULL, address VARCHAR (150) NOT NULL, city VARCHAR (50) NOT NULL, country VARCHAR (50) NOT NULL, email VARCHAR (50), phone VARCHAR (50), website VARCHAR (50), types text[], images text[], schedule json, rating real not null, latitude real not null, longitude real not null, numRevta integer, sections text[], currency varchar(5)); 

create table menuentry (entry_id serial PRIMARY KEY, restaurant_id integer not null, name VARCHAR (150) NOT NULL, section VARCHAR (150) NOT NULL, rating real not null, numReviews integer not null, price real, CONSTRAINT restaurant_to_entry_fkey FOREIGN KEY (restaurant_id) REFERENCES restaurant (restaurant_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE ); 

create table users(user_id varchar(50) unique primary key, name VARCHAR (80) NOT NULL, email VARCHAR (50) NOT NULL, service VARCHAR (10) NOT NULL, image VARCHAR (250) NOT NULL); 

create table favorite(user_id varchar(50) NOT NULL, restaurant_id integer NOT NULL, PRIMARY KEY (user_id, restaurant_id), CONSTRAINT favorites_restaurants_fkey FOREIGN KEY (restaurant_id) REFERENCES restaurant (restaurant_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE, CONSTRAINT favorites_users_fkey FOREIGN KEY (user_id) REFERENCES users (user_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE ); 

create table owner(user_id varchar(50)  NOT NULL, restaurant_id integer NOT NULL, PRIMARY KEY (user_id, restaurant_id), CONSTRAINT owner_restaurants_fkey FOREIGN KEY (restaurant_id) REFERENCES restaurant (restaurant_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE, CONSTRAINT owner_users_fkey FOREIGN KEY (user_id) REFERENCES users (user_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE); 

create table rating(user_id varchar(50)  NOT NULL, entry_id integer NOT NULL, rating real not null, PRIMARY KEY (user_id, entry_id), CONSTRAINT rating_menuentry_fkey FOREIGN KEY (entry_id) REFERENCES menuentry (entry_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE, CONSTRAINT rating_users_fkey FOREIGN KEY (user_id) REFERENCES users (user_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE); 

