#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -A -t -c "
CO=$($PSQL "TRUNCATE customers,services,appointments")
echo -e "\n~~~~~ MY SALON ~~~~~\nWelcome to My Salon, how can I help you?\n"
MENU(){
  echo -e "1) nail_treatments\n2) massages\n3) hair_cutting"
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ [1-3] ]]
  then 
    MENU
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    #check if registered
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    echo $CUSTOMER_NAME
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
    #if not 
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      echo -e "\nWhat time would you like your appointment to be, '$CUSTOMER_NAME'?"
      read SERVICE_TIME
      INSERT_C=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
      INSERT_AP=$($PSQL "INSERT INTO appointments(customer_id,time,service_id) VALUES('$CUSTOMER_ID','$SERVICE_TIME','$SERVICE_ID_SELECTED')")
      echo -e "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  fi  
}
MENU

