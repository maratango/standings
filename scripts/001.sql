--1. результаты матчей
create table games (
game_id     int not null,
home_team   varchar(100) not null,
home_goal   int not null,
guest_team  varchar(100) not null,
guest_goal  int not null
);
--проверка
select * from games;

--2. ключ для games
ALTER TABLE games
    ADD CONSTRAINT gamesPK PRIMARY KEY (game_id);

--3. сиквенс для генерации id(видимо)
CREATE SEQUENCE HIBERNATE_SEQUENCE INCREMENT 1 START 1 no CYCLE;
---проверка
select * from HIBERNATE_SEQUENCE;

--4. вью, который по games считает турнирную таблицу
CREATE OR REPLACE VIEW turnTable AS
with
teams as
    (select team from
        (select home_team as team
        from games
        group by home_team
        union all
        select guest_team as team
        from games
        group by guest_team) as foo
    group by team),
winers as
    (select team, sum(count) as count from
        (select home_team as team, count(*) as count
        from games where
        home_goal > guest_goal
        group by home_team
        union all
        select guest_team as team, count(*) as count
        from games where
        home_goal < guest_goal
        group by guest_team) as foo2
    group by team),
drawers as
    (select team, sum(count) as count from
        (select home_team as team, count(*) as count
        from games where
        home_goal = guest_goal
        group by home_team
        union all
        select guest_team as team, count(*) as count
        from games where
        home_goal = guest_goal
        group by guest_team) as foo3
    group by team),
losers as
    (select team, sum(count) as count from
        (select home_team as team, count(*) as count
        from games where
        home_goal < guest_goal
        group by home_team
        union all
        select guest_team as team, count(*) as count
        from games where
        home_goal > guest_goal
        group by guest_team) as foo4
    group by team),
goals_scored as
    (select team, sum(count) as count from
        (select home_team as team, sum(home_goal) as count
        from games
        group by home_team
        union all
        select guest_team as team, sum(guest_goal) as count
        from games
        group by guest_team) as foo5
    group by team),
goals_conceded as
    (select team, sum(count) as count from
        (select home_team as team, sum(guest_goal) as count
        from games
        group by home_team
        union all
        select guest_team as team, sum(home_goal) as count
        from games
        group by guest_team) as foo6
    group by team)
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
--проверка
select * from turnTable;
--удаление вьюхи
drop view turnTable;