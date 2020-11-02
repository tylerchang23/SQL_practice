/* Soccer Subqueries
https://www.w3resource.com/sql-exercises/soccer-database-exercise/subqueries-exercises-on-soccer-database.php /*

/* 1) Write a query in SQL to find the teams played the first match of EURO cup 2016 */
SELECT s.country_name
FROM soccer_country s
WHERE s.country_id IN (
    SELECT m.team_id
    FROM match_details m
    WHERE match_no = 1
)

/* 2) Write a query in SQL to find the winner of EURO cup 2016. */
SELECT s.country_name
FROM soccer_country s
WHERE s.country_id IN (
    SELECT m.team_id
    FROM match_details m
    WHERE m.play_stage = 'F' AND m.win_lose = 'W'
)

/* 3) Write a query in SQL to find the match with match no, play stage, goal scored, and the audience which was the heighest audience match */
SELECT m.match_no, m.play_stage, m.goal_score, m.audence
FROM match_mast m
WHERE m.audence = (
    SELECT MAX(m.audence)
    FROM match_mast m
)

/* 4) Write a query in SQL to find the match no in which Germany played against Poland  */
SELECT m.match_no
FROM match_details m
WHERE m.team_id = (
    SELECT s.country_id
    FROM soccer_country s
    WHERE s.country_name = 'Germany'
)
OR m.team_id = (
    SELECT s.country_id
    FROM soccer_country s
    WHERE s.country_name = 'Poland'
)
/* At this point ^ , we've only selected the games that Germany and Poland have played INDIVIDUALLY */
GROUP BY match_no
HAVING COUNT(DISTINCT m.team_id) = 2
/* The above two lines then groups the games together, then checks where the two countries played together.

/* 5) Write a query in SQL to find the match no, play stage, date of match, number of gole scored, and the result of the match where Portugal played against Hungary. */
SELECT a.match_no, a.play_stage, a.play_date, a.goal_score, a.results
FROM match_mast a
WHERE a.match_no IN (
    SELECT b.match_no
    FROM match_details b
    WHERE b.team_id = (
        SELECT s.country_id
        FROM soccer_country s
        WHERE s.country_name = 'Portugal')
    OR b.team_id = (
        SELECT s.country_id
        FROM soccer_country s
        WHERE s.country_name = 'Hungary')
    GROUP BY b.match_no
    HAVING COUNT(DISTINCT b.team_id) = 2
)
/* Inside the big subquery, we need to find the match number where either Portugal OR Hungaray played,
Then, similar to the previous question, we first find all the games where EITHER Portugal or Hungary played, group those games together, and find where more than one team particpated
in those grouped games. Those will be the game(s) where both Portugal and Hungary played. */

/* 7) Write a query in SQL to find the teams who played the heighest audience match. */ 
SELECT s.country_name
FROM soccer_country s
WHERE s.country_id IN (
    SELECT g.team_id
    FROM goal_details g
    WHERE g.match_no IN (
        SELECT m.match_no
        FROM match_mast m
        WHERE m.audence = (
            SELECT MAX(m.audence)
            FROM match_mast m
        )
    )
)

/* 8) Write a query in SQL to find the player who scored the last goal for Portugal against Hungary. */

SELECT p.player_name
FROM player_mast p
WHERE p.player_id IN (
    SELECT g.player_id
    FROM goal_details g
    WHERE g.match_no IN (
        SELECT m.match_no
        FROM match_details m
        WHERE m.team_id = 
        (SELECT s.country_id
        FROM soccer_country s
        WHERE s.country_name = 'Portugal')
        OR m.team_id = 
        (SELECT s.country_id
        FROM soccer_country s
        WHERE s.country_name = 'Hungary')
        GROUP BY m.match_no
        HAVING COUNT(DISTINCT m.team_id) = 2
    )
    AND g.team_id = (
        SELECT s.country_id
        FROM soccer_country s
        WHERE s.country_name = 'Portugal'
    )
    ORDER BY g.goal_time DESC
    LIMIT 1
)

/* 9) Write a query in SQL to find the 2nd highest stoppage time which had been added in 2nd half of play */
SELECT MAX(m.stop2_sec)
FROM match_mast m
WHERE m.stop2_sec <> (
    SELECT MAX(m.stop2_sec)
    FROM match_mast m
)

/* 10) Write a query in SQL to find the teams played the match where 2nd highest stoppage time had been added in 2nd half of play. */
SELECT s.country_name
FROM soccer_country s
WHERE s.country_id IN (
    SELECT a.team_id
    FROM match_details a
    WHERE a.match_no IN (
        SELECT b.match_no
        FROM match_mast b
        WHERE b.stop2_sec IN (
            SELECT MAX(b.stop2_sec)
            FROM match_mast b
            WHERE b.stop2_sec <> (
                SELECT MAX(b.stop2_sec)
                FROM match_mast b
            )
        )
    )
)

/* 11) Write a query in SQL to find the match no, date of play and the 2nd highest stoppage time which have been added in the 2nd half of play. */
SELECT m.match_no, m.play_date, MAX(m.stop2_sec)
FROM match_mast m
WHERE m.stop2_sec <> (
    SELECT MAX(m.stop2_sec)
    FROM match_mast m
)
GROUP BY m.match_no, m.play_date
ORDER BY MAX(m.stop2_sec) DESC
LIMIT 1

/* Why does nothing output before the GROUP BY clause???? */

/* 12) Write a query in SQL to find the team which was defeated by Portugal in EURO cup 2016 final. */
SELECT s.country_name
FROM soccer_country s
WHERE s.country_id IN (
    SELECT m.team_id
    FROM match_details m
    WHERE m.match_no IN (
        SELECT m.match_no
        FROM match_details m
        WHERE m.team_id = 
        (SELECT s.country_id
        FROM soccer_country s
        WHERE s.country_name = 'Portugal')
        )
     AND m.win_lose = 'L'
     AND m.play_stage = 'F'
    )

/* 13) Write a query in SQL to find the club which supplied the most number of players to the 2016 EURO cup. */
SELECT p.playing_club, COUNT(p.playing_club)
FROM player_mast p
GROUP BY p.playing_club
HAVING COUNT(p.playing_club) = (
    SELECT MAX(pm.c)
    FROM (
        SELECT p.playing_club, COUNT(p.playing_club) c
        FROM player_mast p
        GROUP BY p.playing_club
    ) pm
)

/* Why do we have to rename COUNT(playing_club)? Can you not do an aggregate on another aggregate?

/* 14) Write a query in SQL to find the player and his jersey number who scored the first penalty of the tournament. */
SELECT p.player_name, p.jersey_no 
FROM player_mast p
WHERE p.player_id IN (
    SELECT g.player_id
    FROM goal_details g
    WHERE g.goal_type = 'P'
    AND g.match_no = (
        SELECT MIN(g.match_no)
        FROM goal_details g
    )
)

/* 15) Write a query in SQL to find the player along with his team and jersey number who scored the first penalty of the tournament. */
SELECT a.player_name, a.jersey_no, d.country_name
FROM player_mast a, goal_details b, goal_details c, soccer_country d
WHERE a.player_id = b.player_id
AND a.team_id = d.team_id
AND a.player_id = (
    SELECT b.player_id
    FROM goal_details b
    WHERE b.goal_type = 'P'
    AND b.match_no = (
        SELECT MIN(c.match_no)
        FROM goal_details c
    )
)
/* Here, there's no way we can escape joining at least two of the tables, since we need to output features from different tables. */

/* 16) Write a query in SQL to find the player who was the goalkeeper for Italy in penalty shootout against Germany in Football EURO cup 2016. */
SELECT a.player_name, a.posi_to_play
FROM player_mast a
WHERE a.player_id IN (
    SELECT b.player_gk
    FROM penalty_gk b
    WHERE b.team_id = (
        SELECT s.country_id
        FROM soccer_country s
        WHERE s.country_name = 'Italy'
    )
)

/* 17) Write a query in SQL to find the number of goals Germany scored at the tournament. */
SELECT COUNT(g.team_id) 
FROM goal_details g
GROUP BY g.team_id
HAVING g.team_id = (
    SELECT s.country_id
    FROM soccer_country s
    WHERE s.country_name = 'Germany'
)

/* 18) Write a query in SQL to find the players along with their jersey no., and playing club, who were the goalkeepers for the England squad for 2016 EURO cup */
SELECT p.player_name, p.jersey_no, p.playing_club, p.posi_to_play
FROM player_mast p
WHERE p.posi_to_play = 'GK'
AND p.team_id = (
    SELECT s.country_id
    FROM soccer_country s
    WHERE s.country_name = 'England'
)

/* 19) Write a query in SQL to find the players with other information under contract to Liverpool were in the Squad of England in 2016 EURO cup. */
SELECT p.player_name, p.jersey_no, p.playing_club
FROM player_mast p
WHERE p.playing_club = 'Liverpool'
AND p.team_id = (
    SELECT s.country_id
    FROM soccer_country s
    WHERE s.country_name = 'England'
)

/* 20) Write a query in SQL to find the player (with other information), who scored the last goal in the 2nd semi final match. */
SELECT p.player_name
FROM player_mast p
WHERE p.player_id = (
    SELECT g.player_id
    FROM goal_details g
    WHERE g.play_stage = 'S'
    ORDER BY g.match_no DESC
    LIMIT 1
)

/* 21)  Write a query in SQL to find the player who was the captain of the EURO cup 2016 winning team.*/
SELECT a.player_name
FROM player_mast a
WHERE a.player_id IN (
    SELECT b.player_captain
    FROM match_captain b
    WHERE b.team_id = (
        SELECT c.team_id
        FROM match_details c
        WHERE c.play_stage = 'F'
        AND c.win_lose = 'W'
    )
)

/* 22) Write a query in SQL to find the number of players played for France in the final. */
SELECT COUNT(p.player_id) + 11
FROM player_in_out p
WHERE p.match_no IN (
    SELECT m.match_no
    FROM match_mast m
    WHERE m.play_stage = 'F'
)
AND p.team_id = (
    SELECT s.country_id
    FROM soccer_country s
    WHERE s.country_name = 'France'
)
AND p.in_out = 'I'

/* 23) Write a query in SQL to find the goalkeeper of the team Germany who didn't concede any goal in their group stage matches. */
SELECT p.player_name, p.posi_to_play
FROM player_mast p
WHERE p.player_id IN (
    SELECT m.player_gk
    FROM match_details m
    WHERE m.play_stage = 'G'
    AND m.team_id = (
        SELECT s.country_id
        FROM soccer_country s
        WHERE s.country_name = 'Germany'
    )
)

/* 24) Write a query in SQL to find the runner-ups in Football EURO cup 2016 */
SELECT s.country_name
FROM soccer_country s
WHERE s.country_id IN (
    SELECT m.team_id
    FROM match_details m
    WHERE m.play_stage = 'F'
    AND m.win_lose = 'L'
)

/* 25) Write a query in SQL to find the maximum penalty shots taken by the teams. */
SELECT COUNT(p.*) shots
FROM penalty_shootout p
GROUP BY p.team_id
HAVING COUNT(p.*) = (
    SELECT MAX(shots)
    FROM (
        SELECT COUNT(*) shots
        FROM penalty_shootout p
        GROUP BY p.team_id
    ) inner_result
)

/* 26) Write a query in SQL to find the maximum number of penalty shots taken by the players. */ 
SELECT COUNT(p.*) shots
FROM penalty_shootout p
GROUP BY p.player_id
HAVING COUNT(p.*) = (
    SELECT MAX(shots)
    FROM (
        SELECT COUNT(*) shots
        FROM penalty_shootout p
        GROUP BY p.player_id
    ) inner_result
)

/* 29) Write a query in SQL to find the player of Portugal who taken the 7th kick against Poland. */
SELECT p.player_id
FROM penalty_shootout p
WHERE p.match_no IN (
    SELECT p.match_no
    FROM peanlty_shootout p
    WHERE p.team_id = (
        SELECT s.country_id
        FROM soccer_country s
        WHERE s.country_name = 'Portugal'
    )
    GROUP BY p.match_no
)
AND p.kick_no = 7


/* 30) Write a query in SQL to find the stage of match where the penalty kick number 23 had been taken */
SELECT m.play_stage
FROM match_mast m
WHERE m.match_no = (
    SELECT p.match_no
    FROM penalty_shootout p
    WHERE p.kick_id = 23
)

/* 31) Write a query in SQL to find the venues where penalty shootout matches played */
SELECT s.venue_name
FROM soccer_venue s
WHERE s.venue_id IN (
    SELECT m.venue_id
    FROM match_mast m
    WHERE m.match_no IN (
        SELECT DISTINCT p.match_no
        FROM penalty_shootout p
    )
)

/* 32)  Write a query in SQL to find the date when penalty shootout matches played. */
SELECT m.play_date
FROM match_mast m
WHERE m.match_no IN (
    SELECT DISTINCT p.match_no
    FROM penalty_shootout p
)

/* 33) Write a query in SQL to find the most quickest goal at the EURO cup 2016, after 5 minutes. */
SELECT MIN(g.goal_time)
FROM goal_details g
WHERE g.goal_time > 5