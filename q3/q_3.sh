#!/bin/bash

read -p "Driver A chooses (Go/Stop): " choice_A
read -p "Driver B chooses (Go/Stop): " choice_B

if [[ "$choice_A" == "Go" && "$choice_B" == "Go" ]]; then
    echo "Outcome: Both go. Crash! Payoff (-1,-1)"
elif [[ "$choice_A" == "Go" && "$choice_B" == "Stop" ]]; then
    echo "Outcome: A goes, B stops. Payoff (1,0)"
elif [[ "$choice_A" == "Stop" && "$choice_B" == "Go" ]]; then
    echo "Outcome: A stops, B goes. Payoff (0,1)"
else
    echo "Outcome: Both stop. Safe! Payoff (0,0)"
fi
