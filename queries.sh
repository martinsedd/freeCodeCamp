#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals) + SUM(opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(total_goals) AS average_goals_per_game FROM (SELECT (winner_goals + opponent_goals) AS total_goals FROM games) AS subquery")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(goals) AS max_goals_in_single_game FROM (SELECT MAX(winner_goals) AS goals FROM games UNION ALL SELECT MAX(opponent_goals) AS goals FROM games) AS subquery")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT t.name AS winner_team_name FROM games g JOIN teams t ON g.winner_id = t.team_id WHERE g.year = 2018 AND g.round = 'Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT DISTINCT team_name FROM (SELECT t1.name AS team_name FROM games g JOIN teams t1 ON g.winner_id = t1.team_id WHERE g.round = 'Eighth-Final' AND g.year = 2014 UNION SELECT t2.name AS team_name FROM games g JOIN teams t2 ON g.opponent_id = t2.team_id WHERE g.round = 'Eighth-Final' AND g.year = 2014) AS teams_played ORDER BY team_name;")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT t.name FROM games g JOIN teams t on g.winner_id = team_id order by t.name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT g.year, t.name FROM games g JOIN teams t ON g.winner_id = t.team_id WHERE g.round = 'Final' ORDER BY year;")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"