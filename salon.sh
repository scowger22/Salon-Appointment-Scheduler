#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"

SELECT_SERVICE() {
if [[ $1 ]]
  then
    echo -e "\n$1"
  else 
    echo "Welcome to My Salon, what service are you looking to book today?"
fi

echo -e "\n1) cut\n2) color\n3) style\n4) trim\n5) extensions\n6) treatment\n7) perm\n8) thermal straightening\n9) balyage and ombre\n10) highlighting\n"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
   1) BOOK_APPOINTMENT ;;
   2) BOOK_APPOINTMENT ;;
   3) BOOK_APPOINTMENT ;;
   4) BOOK_APPOINTMENT ;;
   5) BOOK_APPOINTMENT ;;
   6) BOOK_APPOINTMENT ;;
   7) BOOK_APPOINTMENT ;;
   8) BOOK_APPOINTMENT ;;
   9) BOOK_APPOINTMENT ;;
   10) BOOK_APPOINTMENT ;;
   *) SELECT_SERVICE "I could not find that service. Please enter a valid option." ;;
 esac
}

BOOK_APPOINTMENT() {
  echo -e "\nPlease enter your phone number."
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]
  then 
    echo "I don't have you in our records. What is your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  echo -e "\nWhat time would you like to book your appointment $(echo $CUSTOMER_NAME | sed -E 's/ *$|^ *//g')?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  echo -e "\nI have put you down for a $(echo $SERVICE | sed -E 's/ *$|^ *//g') at $(echo $SERVICE_TIME | sed -E 's/ *$|^ *//g'), $(echo $CUSTOMER_NAME | sed -E 's/ *$|^ *//g')."
}

SELECT_SERVICE
