#!/usr/bin/bash

row=2
column=1

counter=1
while read line ; do
    if [[ "$row" -ne "$counter" ]] ; then
        (( counter++ ))
        continue
    fi

    if [[ "$line" =~ '"' ]] ; then
        IFS='"' read -r -a array <<< "$line"
        for i in "${array[@]}" ; do
            echo "$i"
        done
    else
        awk -v var="$column" 'BEGIN {print var}'
    fi

    # counter=1
    # IFS=',' read -r -a array <<< "$line"
    # for i in "${array[@]}" ; do
        # echo "$i"
        # if [[ "$column" -eq "$counter" ]] && ! [[ "$i" =~ '"' ]] ; then
        #     echo "$i"
        #     (( counter++ ))
        # elif [[ "$column" -ne "$counter" ]] && [[ "$i" =~ '"' ]] ; then
        #     echo "$i"
        # fi
    # done

    break
done < simple.csv
