CREATE TABLE Game (
Gameid INT PRIMARY KEY, 
Game_name VARCHAR2(50) NOT NULL, 
Author VARCHAR2(50) NOT NULL, 
import_date Date NOT NULL, 
Url VARCHAR2(500) NOT NULL);

CREATE TABLE User_names (
Userid INT PRIMARY KEY, 
User_name VARCHAR2(50) NOT NULL, 
User_password VARCHAR2(20) NOT NULL, 
Email VARCHAR2(50) NOT NULL, 
Registration_date Date NOT NULL);

CREATE TABLE Score (
Scoreid INT PRIMARY KEY,
Gameid INT NOT NULL,
Userid INT NOT NULL,
Score INT NOT NULL CHECK(Score>=0),
Score_date Date NOT NULL,
FOREIGN KEY(Gameid) REFERENCES Game(Gameid),
FOREIGN KEY(Userid) REFERENCES User_names(Userid));

CREATE TABLE User_Comments (
Commentid INT PRIMARY KEY,
Gameid INT NOT NULL,
Userid INT NOT NULL,
User_Comment VARCHAR2(500), 
FOREIGN KEY(Gameid) REFERENCES Game(Gameid),
FOREIGN KEY(Userid) REFERENCES User_names(Userid));

CREATE TABLE Rating (
Gameid INT NOT NULL,
Userid INT NOT NULL,
Rating int NOT NULL CHECK(rating>=1 AND Rating<=5),
PRIMARY KEY (Gameid,Userid),
FOREIGN KEY(Gameid) REFERENCES Game(Gameid),
FOREIGN KEY(Userid) REFERENCES User_names(Userid));

CREATE SEQUENCE ids START WITH 1 INCREMENT BY 1;

insert into User_names (Userid, User_name,USER_PASSWORD,EMAIL, REGISTRATION_DATE) values (ids.nextval, 'Peter', '123456','peter@gmail.com','15/05/2012');
insert into User_names (Userid, User_name,USER_PASSWORD,EMAIL, REGISTRATION_DATE) values (ids.nextval, 'Rudolf', 'system','rudolf@gmail.com','23/01/2009');
insert into User_names (Userid, User_name,USER_PASSWORD,EMAIL, REGISTRATION_DATE) values (ids.nextval, 'Oto', '369258','oto@gmail.com','14/08/2014');
insert into User_names (Userid, User_name,USER_PASSWORD,EMAIL, REGISTRATION_DATE) values (ids.nextval, 'Tomas', 'qwerty','tomas@gmail.com','12/12/2012');
insert into User_names (Userid, User_name,USER_PASSWORD,EMAIL, REGISTRATION_DATE) values (ids.nextval, 'Janka', '987654321','janka@gmail.com','20/05/2009');

insert into Score (Scoreid,GAMEID,Userid,Score, SCORE_DATE) values (ids.nextval, 1,6,1000,'28/06/2016');
insert into Score (Scoreid,GAMEID,Userid,Score, SCORE_DATE) values (ids.nextval, 2,7,10000,'25/06/2016');
insert into Score (Scoreid,GAMEID,Userid,Score, SCORE_DATE) values (ids.nextval, 3,8,69457,'26/06/2016');
insert into Score (Scoreid,GAMEID,Userid,Score, SCORE_DATE) values (ids.nextval, 2,9,123,'27/06/2016');
insert into Score (Scoreid,GAMEID,Userid,Score, SCORE_DATE) values (ids.nextval, 5,6,9999999,'20/06/2016');

insert into USER_COMMENTS (COMMENTID,GAMEID,USERID,USER_COMMENT) values (ids.nextval, 1,6,'Great!');
insert into USER_COMMENTS (COMMENTID,GAMEID,USERID,USER_COMMENT) values (ids.nextval, 1,7,'WoW! Great!');
insert into USER_COMMENTS (COMMENTID,GAMEID,USERID,USER_COMMENT) values (ids.nextval, 1,8,'Amazing!');
insert into USER_COMMENTS (COMMENTID,GAMEID,USERID,USER_COMMENT) values (ids.nextval, 2,6,'Bullshit');
insert into USER_COMMENTS (COMMENTID,GAMEID,USERID,USER_COMMENT) values (ids.nextval, 3,10,'Good one!');

insert into Rating (GAMEID,USERID,RATING) values (1,6,5);
insert into Rating (GAMEID,USERID,RATING) values (4,7,4);
insert into Rating (GAMEID,USERID,RATING) values (1,8,4);
insert into Rating (GAMEID,USERID,RATING) values (2,10,1);
insert into Rating (GAMEID,USERID,RATING) values (5,6,3);

insert into Game (Gameid, Game_name, Author,import_date, Url) values (ids.nextval, 'Minesweeper', 'Gypsy King','04/12/1953','http://gypsy.sk/');
insert into Game (Gameid, Game_name, Author,import_date, Url) values (ids.nextval, 'Opal Miner', 'Karol','05/07/2005','http://opalovebane.sk');
insert into Game (Gameid, Game_name, Author,import_date, Url) values (ids.nextval, 'Slither', 'Slavo','01/06/2016','http://slither.io');
insert into Game (Gameid, Game_name, Author,import_date, Url) values (ids.nextval, 'Wolf', 'Mato','01/09/1939','http://wolf.com/');
insert into Game (Gameid, Game_name, Author,import_date, Url) values (ids.nextval, 'Minecraft', 'Tomas Polkabla','11/03/2000','https://mojang.com/');

CREATE INDEX game_name ON game (game_name);
CREATE INDEX user_name ON User_Names (User_name);

1.       Zoznam hráèov utriedený pod¾a dátumu registrácie
Create view view1 as SELECT * FROM USER_NAMES ORDER BY REGISTRATION_DATE;

2.       Zoznam hier
Create view view2 as  SELECT * FROM GAME;

3.       Zoznam hier s komentármi a menami používate¾ov
Create view view3 as  SELECT g.GAME_NAME,us.USER_NAME,u.USER_COMMENT from USER_COMMENTS u join Game g ON u.GAMEID = g.GAMEID join USER_NAMES us on us.USERID = u.USERID;

4.       Hráè s najdlhším menom
Create view view4 as  SELECT User_name FROM User_names WHERE length(USER_NAME) = (SELECT max(length(USER_NAME)) FROM USER_NAMES);

5.       Zoznam hier, ktoré nehral nikto (nemajú záznam v Score)
Create view view5 as Select g.Game_name from game g left join score s on s.GAMEID = g.GAMEID where s.SCORE IS NULL;

6.       Zoznam používate¾ov, ktorí nehodnotili žiadnu hru
Create view view5 as  Select u.User_name from USER_NAMES u left join rating r on u.USERID = r.USERID where r.RATING IS NULL;

7.       Zoznam používate¾ov, ktorí nehodnotili jednu konkrétnu hru (napr. Minesweeper)
Create view view7 as Select u.User_name from USER_NAMES u left join rating r on u.USERID = r.USERID left join game g on r.GAMEID = g.GAMEID where g.GAME_NAME<>'Minesweeper' AND r.RATING IS NOT NULL;

8.       Poèet hier, poèet hráèov, poèet komentárov, poèet hodnotení
Create view view8 as select count(G.GameId) as pocet_hier, count(C.User_COMMENT) as pocet_komentarov, count(P.UserId)as pocet_pouzivatelov, count(*) as pocet_hodnoteni from Game G left join USER_COMMENTS C on C.GAMEID=G.GAMEID left join USER_NAMES P on P.UserId=C.USERID join GAME g on G.GAMEID = C.GAMEID; 

9.       Najstaršia hra
Create view view9 as select min(import_date) from game;

10.   Zoznam hier s ich priemerným ratingom a poètom hodnotení
Create view view10 as Select g.GAME_NAME, count(r.RATING), AVG(r.RATING) from game g join rating r on r.GAMEID = g.GAMEID GROUP BY g.GAME_NAME; 

11.   Najviac komentované hry
Create view commentnumbers as Select g.game_name, count(u.USER_COMMENT) as pocet from game g join USER_COMMENTS u on u.GAMEID = g.GAMEID GROUP BY g.GAME_NAME;
Create view view11 as Select Game_name, pocet from commentnumbers where pocet=(Select MAX(pocet) from commentnumbers);

12.   Zoznam hráèov s ich poètom hraním hier a celkovým skóre, ktoré nahrali 
Create view view12 as Select u.user_name, count(s.SCORE), sum(s.SCORE) from USER_NAMES u join score s on u.USERID = s.USERID GROUP BY u.USER_NAME;

13.   Meno hráèa, ktorý hral naposledy hru
Create view view13 as Select u.User_name, s.SCORE_DATE from USER_NAMES u join score s on u.USERID = s.USERID where s.SCORE_DATE = (Select MAX(SCORE_DATE) from score);

14.   Poèet komentárov pre najob¾úbenejšiu hru
create view average as Select g.GAMEID, g.GAME_NAME, AVG(r.RATING) as Average from game g join rating r on r.GAMEID = g.GAMEID GROUP BY g.GAME_NAME,g.GAMEID; 
create view best_Game as Select GAMEID, GAME_NAME, Average from average where average= (Select MAX(Average) from average);
Create view view14 as Select b.GAME_NAME, count(b.GAME_NAME) from best_game b join USER_COMMENTS uc on uc.GAMEID = b.GAMEID GROUP BY b.GAME_NAME;

15.   Mená hráèov s poètom komentárov, ktoré pridali k hrám
Create view view15 as Select u.user_name, count(uc.USER_COMMENT) from USER_NAMES u join USER_COMMENTS uc on uc.USERID = u.USERID GROUP BY u.USER_NAME;
