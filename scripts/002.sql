--1.1. пользователи
create table users (
user_id		int not null,
login		varchar(100) not null,
password	varchar(100) not null,
email		varchar(100) not null,
create_date	timestamp not null
);

--1.2. ключ для users
ALTER TABLE users
    ADD CONSTRAINT usersPK PRIMARY KEY (user_id);

--1.3. сиквенс для генерации id пользователей
CREATE SEQUENCE usersSequence INCREMENT 1 START 1 no CYCLE;

--1.4. функция по добавлению нового пользователя
CREATE OR REPLACE function fn_checkAndAddUser(p_login text, p_password text, p_email text)
	RETURNS boolean
	LANGUAGE plpgsql
as $function$
begin
	lock table users in ACCESS EXCLUSIVE mode;
	if exists(select 1 from users where upper(login) = upper(p_login))
		then
			return false;
		else
			insert into users values(nextval('usersSequence'), p_login, p_password, p_email, now());
			return true;
	end if;
end;
$function$;


--2.1. результаты матчей
create table games (
game_id     	int not null,
tournament_id	int not null,
home_team   	varchar(100) not null,
home_goal   	int not null,
guest_team  	varchar(100) not null,
guest_goal  	int not null,
create_date		timestamp not null
);

--2.2. ключ для games
ALTER TABLE games
    ADD CONSTRAINT gamesPK PRIMARY KEY (game_id);

--2.3. сиквенс для генерации id(видимо)
CREATE SEQUENCE HIBERNATE_SEQUENCE INCREMENT 1 START 1 no CYCLE;


--3.1. турниры
create table tournaments (
tournament_id	int not null,
owner_id		int not null,
name			varchar(100) not null,
create_date		timestamp not null
);

--3.2. ключ для турниры
ALTER TABLE tournaments
    ADD CONSTRAINT tournamentsPK PRIMARY KEY (tournament_id);

--3.3. сиквенс для генерации id турниры
CREATE SEQUENCE tournamentsSequence INCREMENT 1 START 1 no CYCLE;


--4.1. Функция, которая по games считает турнирную таблицу по играм турнира
CREATE OR REPLACE function fn_turnStandings(p_turnName text, p_login text, p_password text)
	RETURNS TABLE(team varchar, games numeric, point numeric, win numeric, draw numeric, lose numeric, gs numeric, gc numeric, gd numeric)
	LANGUAGE plpgsql
as $function$
begin
	RETURN QUERY
	with
	turnGames as
		(select * from games where tournament_id =
			(select tournament_id from tournaments
				where
				name = p_turnName
				and owner_id = 
					(select user_id from users
						where
						login = p_login
						and password = p_password))),
	teams as
	    (select foo.team from
	        (select home_team as team
	        from turnGames
	        group by home_team
	        union all
	        select guest_team as team
	        from turnGames
	        group by guest_team) as foo
	    group by foo.team),
	winers as
	    (select foo2.team, sum(foo2.count) as count from
	        (select home_team as team, count(*) as count
	        from turnGames where
	        home_goal > guest_goal
	        group by home_team
	        union all
	        select guest_team as team, count(*) as count
	        from turnGames where
	        home_goal < guest_goal
	        group by guest_team) as foo2
	    group by foo2.team),
	drawers as
	    (select foo3.team, sum(foo3.count) as count from
	        (select home_team as team, count(*) as count
	        from turnGames where
	        home_goal = guest_goal
	        group by home_team
	        union all
	        select guest_team as team, count(*) as count
	        from turnGames where
	        home_goal = guest_goal
	        group by guest_team) as foo3
	    group by foo3.team),
	losers as
	    (select foo4.team, sum(foo4.count) as count from
	        (select home_team as team, count(*) as count
	        from turnGames where
	        home_goal < guest_goal
	        group by home_team
	        union all
	        select guest_team as team, count(*) as count
	        from turnGames where
	        home_goal > guest_goal
	        group by guest_team) as foo4
	    group by foo4.team),
	goals_scored as
	    (select foo5.team, sum(foo5.count) as count from
	        (select home_team as team, sum(home_goal) as count
	        from turnGames
	        group by home_team
	        union all
	        select guest_team as team, sum(guest_goal) as count
	        from turnGames
	        group by guest_team) as foo5
	    group by foo5.team),
	goals_conceded as
	    (select foo6.team, sum(foo6.count) as count from
	        (select home_team as team, sum(guest_goal) as count
	        from turnGames
	        group by home_team
	        union all
	        select guest_team as team, sum(home_goal) as count
	        from turnGames
	        group by guest_team) as foo6
	    group by foo6.team)
	select
	    t.team,
	    (COALESCE(w.count,0) + COALESCE(d.count, 0) + COALESCE(l.count,0)) as games,
	    (COALESCE(w.count, 0) * 3 + COALESCE(d.count, 0)) as point,
	    COALESCE(w.count,0) as win,
	    COALESCE(d.count,0) as draw,
	    COALESCE(l.count,0) as lose,
	    COALESCE(gs.count,0) as gs,
	    COALESCE(gc.count,0) as gc,
	    (COALESCE(gs.count,0) - COALESCE(gc.count,0)) as gd
	from teams t
	left join winers w on t.team=w.team
	left join drawers d on t.team=d.team
	left join losers l on t.team=l.team
	left join goals_scored gs on t.team=gs.team
	left join goals_conceded gc on t.team=gc.team
	order by point desc, gd desc;
return;
end;
$function$
;
--------================================
--------================================
select * from users;
select * from games;
select * from tournaments;
select fn_checkAndAddUser('testL2', 'testP2', 'testE2');
select * from fn_turnStandings('England premier league 2021-2022', 'test1', 'test1');
select * from usersSequence;
select * from HIBERNATE_SEQUENCE;
select * from tournamentsSequence;
-------------------------
drop table users;
drop table games;
drop table tournaments;
drop function fn_checkAndAddUser(text, text, text);
drop function fn_turnStandings(text, text, text);
drop sequence usersSequence;
drop sequence HIBERNATE_SEQUENCE;
drop sequence tournamentsSequence;
-------------------------
insert into users values(nextval('usersSequence'), test1, test1, null, now());

insert into tournaments values(nextval('tournamentsSequence'), 1, 'England premier league 2021-2022', now());
insert into tournaments values(nextval('tournamentsSequence'), 1, 'La liga 2021-2022', now());

insert into games values(nextval('HIBERNATE_SEQUENCE'), 1, 'Chelsea', 1, 'Manchester united', 0, now());
insert into games values(nextval('HIBERNATE_SEQUENCE'), 1, 'Wigan', 0, 'Totenham', 3, now());
insert into games values(nextval('HIBERNATE_SEQUENCE'), 1, 'Liverpool', 2, 'Manchester city', 2, now());
-------------------------
select exists(select 1 from users where upper(login) = upper('testL') and password = 'testP');
select name from tournaments where owner_id = (select user_id from users where upper(login) = upper('test4') and password = 'test4');
select * from pg_stat_activity where application_name = 'PostgreSQL JDBC Driver';
--------================================
--------================================




