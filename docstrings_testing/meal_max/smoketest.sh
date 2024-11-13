#!/bin/bash

# Define the base URL for the Flask API
BASE_URL="http://localhost:5000/api"

# Flag to control whether to echo JSON output
ECHO_JSON=false

# Parse command-line arguments
while [ "$#" -gt 0 ]; do
  case $1 in
    --echo-json) ECHO_JSON=true ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done


###############################################
#
# Health checks
#
###############################################

# Function to check the health of the service
check_health() {
  echo "Checking health status..."
  curl -s -X GET "$BASE_URL/health" | grep -q '"status": "healthy"'
  if [ $? -eq 0 ]; then
    echo "Service is healthy."
  else
    echo "Health check failed."
    exit 1
  fi
}

# Function to check the database connection
check_db() {
  echo "Checking database connection..."
  curl -s -X GET "$BASE_URL/db-check" | grep -q '"database_status": "healthy"'
  if [ $? -eq 0 ]; then
    echo "Database connection is healthy."
  else
    echo "Database check failed."
    exit 1
  fi
}






###############################################
#
# Meal operations
#
###############################################

# Function to add a meal to the database
add_meal() {
  echo "Adding a meal to the database..."
  response=$(curl -s -X POST "$BASE_URL/create-meal" \
    -H "Content-Type: application/json" \
    -d '{"meal": "Burger", "cuisine": "American", "price": 10.0, "difficulty": "MED"}')
  
  [ "$ECHO_JSON" = true ] && echo "$response"
  echo "Meal added successfully."
}

# Function to retrieve a meal by ID
get_meal_by_id() {
  echo "Retrieving meal by ID..."
  response=$(curl -s -X GET "$BASE_URL/get-meal-by-id/1")
  [ "$ECHO_JSON" = true ] && echo "$response"
  echo "Meal retrieved successfully."
}

# Function to retrieve a meal by name
get_meal_by_name() {
  echo "Retrieving meal by name..."
  response=$(curl -s -X GET "$BASE_URL/get-meal-by-name/Burger")
  [ "$ECHO_JSON" = true ] && echo "$response"
  echo "Meal retrieved successfully by name."
}

# Function to delete a meal by ID
delete_meal() {
  echo "Deleting a meal by ID..."
  response=$(curl -s -X DELETE "$BASE_URL/delete-meal/1")
  [ "$ECHO_JSON" = true ] && echo "$response"
  echo "Meal deleted successfully."
}

###############################################
#
# Battle operations
#
###############################################

# Function to prepare meals as combatants
prepare_combatants() {
  echo "Preparing meals as combatants..."
  # Add two meals for the battle
  curl -s -X POST "$BASE_URL/create-meal" \
    -H "Content-Type: application/json" \
    -d '{"meal": "Pizza", "cuisine": "Italian", "price": 12.0, "difficulty": "HIGH"}'
  
  curl -s -X POST "$BASE_URL/create-meal" \
    -H "Content-Type: application/json" \
    -d '{"meal": "Sushi", "cuisine": "Japanese", "price": 15.0, "difficulty": "LOW"}'

  # Prepare each meal as a combatant
  response=$(curl -s -X POST "$BASE_URL/prep-combatant" \
    -H "Content-Type: application/json" \
    -d '{"meal": "Pizza"}')
  [ "$ECHO_JSON" = true ] && echo "$response"

  response=$(curl -s -X POST "$BASE_URL/prep-combatant" \
    -H "Content-Type: application/json" \
    -d '{"meal": "Sushi"}')
  [ "$ECHO_JSON" = true ] && echo "$response"
  
  echo "Combatants prepared successfully."
}

# Function to start a battle
start_battle() {
  echo "Starting a battle..."
  response=$(curl -s -X GET "$BASE_URL/battle")
  [ "$ECHO_JSON" = true ] && echo "$response"
  echo "Battle completed."
}

# Function to clear combatants
clear_combatants() {
  echo "Clearing all combatants..."
  response=$(curl -s -X POST "$BASE_URL/clear-combatants")
  [ "$ECHO_JSON" = true ] && echo "$response"
  echo "Combatants cleared."
}

###############################################
#
# Leaderboard
#
###############################################

# Function to retrieve the leaderboard
get_leaderboard() {
  echo "Retrieving leaderboard..."
  response=$(curl -s -X GET "$BASE_URL/leaderboard")
  [ "$ECHO_JSON" = true ] && echo "$response"
  echo "Leaderboard retrieved successfully."
}

###############################################
#
# Run all smoketests
#
###############################################

echo "Starting smoketests for meal_max..."

check_health
check_db
add_meal
get_meal_by_id
get_meal_by_name
prepare_combatants
start_battle
clear_combatants
get_leaderboard
delete_meal

echo "Smoketests complete."