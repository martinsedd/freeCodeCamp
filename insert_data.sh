#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#Purge tables before running script
TRUNCATE_TABLES=$($PSQL "TRUNCATE TABLE games, teams")
echo $TRUNCATE_TABLES
#Check if tables have been purged
if [[ $TRUNCATE_TABLES == 'TRUNCATE TABLE' ]]
then
    #Brings .csv in and reads it looking for commas as separators
    cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
    do 
        #checking to see if team name is already in
        if [[ $WINNER != "winner" ]]
        then
            TEAM1_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
            if [[ -z $TEAM1_NAME ]]
            then
                #stores query feedback into variable
                INSERT_TEAM1_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
                    #checks query result to see if team was added
                    if [[ $INSERT_TEAM1_NAME == "INSERT 0 1" ]]
                    then
                        #console feeback, because why not?
                        echo "Inserted team $WINNER"
                    fi
            fi
        fi

        if [[ $OPPONENT != "opponent" ]]
        then
            TEAM2_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
            if [[ -z $TEAM2_NAME ]]
            then
                #stores query feedback into variable
                INSERT_TEAM2_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
                    #checks query result to see if team was added
                    if [[ $INSERT_TEAM2_NAME == "INSERT 0 1" ]]
                    then
                        #console feeback, because why not?
                        echo "Inserted team $OPPONENT"
                    fi
            fi
        fi

        if [[ $YEAR != "year" ]]
        then
            WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
            
            OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

            INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
            VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

            if [[ $INSERT_GAME == "INSERT 0 1" ]]
            then
                echo "New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS"
            fi
        fi
    done
fi
