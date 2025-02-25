#!/bin/bash

Kap_Rou() {
    local num=$1
    local count=0

    while [ "$num" -ne 6174 ]; do
        printf -v num "%04d" $num

        ascending=$(echo $num | grep -o . | sort | tr -d '\n')
        descending=$(echo $num | grep -o . | sort -r | tr -d '\n')

        num=$((10#$descending - 10#$ascending))
        count=$((count + 1))

        if [ "$num" -eq 0 ]; then
            echo "Kaprekar's routine stuck at 0. No convergence to 6174."
            return
        fi
    done

    echo "It took $count iterations to reach Kaprekar's constant (6174)."
}


read -p "Enter a 4-digit number: " input

if ! [[ "$input" =~ ^[0-9]{4}$ ]]; then
    echo "Error: Please enter a valid 4-digit number."
    exit 1
fi

digits=$(echo $input | grep -o . | sort -u | wc -l)
if [ "$digits" -eq 1 ]; then
    echo "Error: All digits are the same. Kaprekar's routine is not applicable."
    exit 1
fi

Kap_Rou "$input"
#comment 1
#comment 2
#comment 3
#comment 4
#comment 5
#comment 6
#comment 7
#comment 8
#comment 9
#comment 10