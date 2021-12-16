#!/bin/bash
for i in $(seq -f "%02g" 1 25)
do
    printf "Day $i\n"
    cd "./$i"
    ruby "$i.rb"
    printf "\n"
    cd ..
done
