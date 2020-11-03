/* Soccer Joins */
/* https://www.w3resource.com/sql-exercises/soccer-database-exercise/joins-exercises-on-soccer-database.php */

/* 1) Write a query in SQL to find the name of the venue with city where the EURO cup 2016 final match was played. */
SELECT a.venue_name, b.city
FROM soccer_venue a
JOIN soccer_city b
ON a.city_id = b.city_id
JOIN match_mast c
ON a.venue_id = c.venue_id
WHERE c.play_stage = 'F'

/* 2) Write a query in SQL to find the number of goal scored by each team in every match within normal play schedule. */
SELECT s.country_name, m.goal_score
FROM match_details m
JOIN soccer_country s
ON m.team_id = s.country_id
WHERE m.decided_by = 'N'

/* 3) Write a query in SQL to find the total number of goals scored by each player within normal play schedule and arrange the
result set according to the heighest to lowest scorer. */
SELECT COUNT(*), s.country_name
FROM goal_details g
JOIN player_mast p
ON g.player_id = p.player_id
JOIN soccer_country s
ON p.team_id = s.country_id
WHERE g.goal_schedule = 'NT'
GROUP BY g.player_id, s.country_name
ORDER BY COUNT(*) DESC

/* 4) Write a query in SQL to find the highest individual scorer in EURO cup 2016 */
SELECT p.player_name, COUNT(p.player_name)
FROM player_mast p
JOIN goal_details g
ON p.player_id = g.player_id
GROUP BY p.player_id
ORDER BY COUNT(p.player_name) DESC 
LIMIT 1

/* 5) Write a query in SQL to find the scorer of only goal along with his country and jersey number in the final of EURO cup 2016. */
SELECT g.goal_id, p.player_name, s.country_name
FROM goal_details g
JOIN player_mast p
ON g.player_id = p.player_id
JOIN soccer_country s
ON p.team_id = s.country_id
WHERE g.match_no = (
    SELECT MAX(g.match_no)
    FROM goal_details g
)

/* 6) Write a query in SQL to find the country where Football EURO cup 2016 held. */
SELECT a.country_name
FROM soccer_country a
JOIN soccer_city b
ON a.country_id = b.country_id
JOIN soccer_venue c
ON b.city_id = c.city_id

/* 7) Write a query in SQL to find the player who socred first goal of EURO cup 2016. */
SELECT p.player_name
FROM player_mast p
JOIN goal_details g
WHERE g.goal_id = (
    SELECT MIN(g.goal_id)
    FROM goal_details g
)

/* 8) Write a query in SQL to find the name and country of the referee who managed the opening match. */
SELECT r.referee_name, s.country_id
FROM referee_mast r
JOIN soccer_country s
ON r.country_id = s.country_id
JOIN match_mast m
ON r.referee_id = m.referee_id
WHERE m.match_no = (
    SELECT MIN(m.match_no)
    FROM match_mast m
)

/* 9) Write a query in SQL to find the name and country of the referee who managed the final match. */
SELECT r.referee_name, s.country_id
FROM referee_mast r
JOIN soccer_country s
ON r.country_id = s.country_id
JOIN match_mast m
ON r.referee_id = m.referee_id
WHERE m.match_no = (
    SELECT MAX(m.match_no)
    FROM match_mast m
)

/* 10) Write a query in SQL to find the name and country of the referee who assisted the referee in the opening match. */
SELECT a.ass_ref_name, s.country_name
FROM asst_referee_mast a
JOIN soccer_country s
ON a.country_id = s.country_id
JOIN match_details m
ON a.ass_ref_id = m.ass_ref
WHERE m.match_no = (
    SELECT MIN(m.match_no)
    FROM match_deatils m
)

/* 11) Write a query in SQL to find the name and country of the referee who assisted the referee in the final match. */
SELECT a.ass_ref_name, s.country_name
FROM asst_referee_mast a
JOIN soccer_country s
ON a.country_id = s.country_id
JOIN match_details m
ON a.ass_ref_id = m.ass_ref
WHERE m.match_no = (
    SELECT MAX(m.match_no)
    FROM match_deatils m
)

/* 12) Write a query in SQL to find the city where the opening match of EURO cup 2016 played. */
SELECT a.city
FROM soccer_city a
JOIN soccer_venue b
ON a.city_id = b.city_id
JOIN match_mast m
ON b.venue_id = m.venue_id
WHERE m.match_no = (
    SELECT MIN(m.match_no)
    FROM match_mast m
)

/* 13) Write a query in SQL to find the stadium hosted the final match of EURO cup 2016 along with the capacity, and audience for that match. */
SELECT s.venue_name, s.aud_capacity, m.audence
FROM soccer_venue s
JOIN match_mast m
ON s.venue_id = m.venue_id
WHERE m.match_no = (
    SELECT MAX(m.match_no)
    FROM match_mast m
)

/* 14) Write a query in SQL to compute a report that contain the number of matches played in each venue along with their city. */
SELECT a.venue_name, b.city, COUNT(a.venue_id)
FROM soccer_venue a
JOIN soccer_city b
ON a.city_id = b.city_id
JOIN match_mast c
ON a.venue_id = c.venue_id
GROUP BY a.venue_id, b.city

/* 15) Write a query in SQL to find the player who was the first player to be sent off at the tournament EURO cup 2016. */
SELECT a.sent_off, a.match_no, a.booking_time, b.player_name
FROM player_booked a
JOIN player_mast b
ON a.player_id = b.player_id
WHERE a.sent_off = 'Y'
AND a.match_no = (
    SELECT MIN(a.match_no)
    FROM player_booked a
)

/* 16) Write a query in SQL to find the teams that scored only one goal in the tournament */
SELECT a.points, b.country_name
FROM soccer_team a
JOIN soccer_country b
ON a.team_id = b.country_id
WHERE a.points = 1

/* 17) Write a query in SQL to find the yellow cards received by each country. */
SELECT s.country_name
FROM soccer_country s
JOIN player_booked p
ON s.country_id = p.team_id
WHERE s.sent_off = 'Y'

/* 18) Write a query in SQL to find the venue with number of goals that has seen. */
SELECT d.venue_name, COUNT(d.venue_name)
FROM soccer_venue d
JOIN match_mast c
ON d.venue_id = c.venue_id
JOIN goal_details b
ON c.match_no = b.match_no
GROUP BY d.venue_name

/* 19) Write a query in SQL to find the match where no stoppage time was added in 1st half of play. */
SELECT b.match_no, c.country_name
FROM match_mast b
JOIN match_details a
ON b.match_no = a.match_no
JOIN soccer_country c
ON a.team_id = c.country_id
WHERE b.stop1_sec = 0

/* 20) Write a query in SQL to find the team(s) who conceded the most goals in EURO cup 2016. */
SELECT b.country_name
FROM soccer_country b
JOIN soccer_team a
ON b.country_id = a.team_id
WHERE a.goal_agnst = (
    SELECT MAX(a.goal_agnst)
    FROM soccer_team a
)

/* 21) Write a query in SQL to find the match where highest stoppege time added in 2nd half of play. */
SELECT b.match_no, c.country_name
FROM match_mast b
JOIN match_details a
ON b.match_no = a.match_no
JOIN soccer_country c
ON a.team_id = c.country_id
WHERE b.stop2_sec = (
    SELECT MAX(b.stop2_sec)
    FROM match_mast b
)

/* 22) Write a query in SQL to find the matches ending with a goalless draw in group stage of play */
SELECT DISTINCT m.match_no
FROM match_details m
WHERE m.play_stage = 'G'
AND m.win_lose = 'D'
AND m.goal_score = 0

/* 23) Write a query in SQL to find the match no. and the teams played in that match where the 2nd highest stoppage time had been added in the 2nd half of play. */
SELECT a.match_no, c.country_name
FROM match_mast a
JOIN match_details b
ON a.match_no = b.match_no
JOIN soccer_country c
ON b.team_id = c.country_id
WHERE a.stop2_sec  = (
    SELECT MAX(a.stop2_sec)
    FROM match_mast a
    WHERE a.stop2_sec NOT IN (
        SELECT MAX(a.stop2_sec)
        FROM match_mast a
    )
)

/* 26) Write a query in SQL to find the oldest player to have appeared in a EURO cup 2016 match */
SELECT p.player_name, s.country_name, p.dt_of_bir
FROM player_mast p
JOIN soccer_country s
ON p.team_id = s.country_id
WHERE p.dt_of_bir = (
    SELECT MIN(p.dt_of_bir)
    FROM player_mast p
)

/* 27) Write a query in SQL to find those teams which scored three goals in a single game at this tournament. */
SELECT DISTINCT s.country_name
FROM soccer_country s
JOIN match_details m
ON s.country_id = m.team_id
WHERE m.goal_score = 3

/* 28) Write a query in SQL to find the teams with other information that finished bottom of their respective groups after conceding four times in three games. */
SELECT b.country_name
FROM soccer_country b 
JOIN soccer_team a
ON b.country_id = a.team_id
WHERE a.goal_agnst = 4 
AND a.group_position = 4

/* 29) Write a query in SQL to find those three players with other information, who contracted to Lyon participated in the EURO cup 2016 Finals */
SELECT DISTINCT p.player_name, s.country_name, m.play_stage
FROM player_mast p
JOIN soccer_country s
ON p.team_id = s.country_id
JOIN match_details m
ON p.team_id = m.team_id
WHERE p.playing_club = 'Lyon'
AND m.play_stage = 'F'

/* 30) Write a query in SQL to find the final four teams in the tournament */
SELECT s.country_name
FROM soccer_country s
JOIN match_details m
ON s.country_id = m.team_id
WHERE m.play_stage = 'S'

/* 31) Write a query in SQL to find the captains for the top four teams with other information which participated in the semifinals (match 48 and 49) in the tournament. */
SELECT DISTINCT s.country_name, p.player_name
FROM soccer_country s
JOIN match_captain m
ON s.country_id = m.team_id
JOIN player_mast p
ON m.player_captain = p.player_id
WHERE m.match_no IN (48,49)

/* 32) Write a query in SQL to find the captains with other information for all the matches in the tournament. */
SELECT DISTINCT s.country_name, p.player_name
FROM soccer_country s
JOIN match_captain m
ON s.country_id = m.team_id
JOIN player_mast p
ON m.player_captain = p.player_id

/* 33) Write a query in SQL to find the captain and goal keeper with other information for all the matches for all the team. */
SELECT a.country_name
FROM soccer_country a
JOIN match_captain b
ON a.country_id = b.team_id
JOIN player_mast c
ON b.player_captain = c.player_id
WHERE c.posi_to_play = 'GK'

/* 34) Write a query in SQL to find the player who was selected for the Man of the Match Award in the finals of EURO cup 2016. */
SELECT s.country_name, p.player_name, m.play_stage
FROM soccer_country s
JOIN player_mast p
ON s.country_id = p.team_id
JOIN match_mast m
ON p.player_id = m.plr_of_match
WHERE m.play_stage = 'F'

/* 35) Write a query in SQL to find the substitute players who came into the field in the first half of play within normal play schedule */
SELECT DISTINCT a.in_out, a.play_schedule, a.play_half, b.player_name
FROM player_in_out a
JOIN player_mast b
ON a.player_id = b.player_id
WHERE a.in_out = 'I'
AND a.play_schedule = 'NT'
AND a.play_half = 1

/* 36) Write a query in SQL to prepare a list for the player of the match against each match.   */
SELECT m.plr_of_match, p.player_name, s.country_name
FROM match_mast m
JOIN player_mast p
ON m.plr_of_match = p.player_id
JOIN soccer_country s
ON p.team_id = s.country_id