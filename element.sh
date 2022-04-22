#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

# ~~~ ATOMIC_NUMBER ~~~
# if arg is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
  #get element by atomic number
  ELEMENT_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, \
                                 p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius \
                          FROM elements AS e \
                          LEFT JOIN properties AS p USING(atomic_number) \
                          LEFT JOIN types AS t USING(type_id) \
                          WHERE e.atomic_number = $1;")
  # if result is null
  if [[ -z $ELEMENT_RESULT ]]
  then
    # notify and exit
    echo -e "I could not find that element in the database."
  else
    # present element details
    read  NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL BAR <<< "$ELEMENT_RESULT"
    echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). \
It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of \
$MELT celsius and a boiling point of $BOIL celsius."
  fi
  exit
fi

# ~~~ ATOMIC SYMBOL ~~~
# if atomic symbol
ARG1=$(echo "$1" | wc -m)
if [[ "$ARG1" < 4 ]]
then
  # Get with atomic symbol
  ELEMENT_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, \
                                 p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius \
                          FROM elements AS e \
                          LEFT JOIN properties AS p USING(atomic_number) \
                          LEFT JOIN types AS t USING(type_id) \
                          WHERE e.symbol ILIKE('$1');")
  # if result is null
  if [[ -z $ELEMENT_RESULT ]]
  then
    # notify and exit
    echo -e "I could not find that element in the database."
  else
    # present element details
    read  NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL BAR <<< "$ELEMENT_RESULT"
    echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). \
It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of \
$MELT celsius and a boiling point of $BOIL celsius."
  fi
  exit
fi

# ~~~ ATOMIC NAME ~~~
# if atomic name or anything else try it
# Get with atomic name
ELEMENT_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, \
                                 p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius \
                          FROM elements AS e \
                          LEFT JOIN properties AS p USING(atomic_number) \
                          LEFT JOIN types AS t USING(type_id) \
                          WHERE e.name ILIKE('$1');")
# if result is null
if [[ -z $ELEMENT_RESULT ]]
then
  # notify and exit
  echo -e "I could not find that element in the database."
else
  # present element details
  read  NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL BAR <<< "$ELEMENT_RESULT"
  echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). \
It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of \
$MELT celsius and a boiling point of $BOIL celsius."
fi
