#!/bin/bash

person_name="John"


elements=( person )

for element in ${elements[@]}
do
    #dynamicly making variable name
    current_name=$element\_name
    #getting values
    echo "---"
    echo "Name: Hello ${!current_name}"
    echo "---"
done