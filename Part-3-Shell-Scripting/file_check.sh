#!/bin/bash

read -p "Enter file path: " file

if [ -e "$file" ]
then
    echo "File exists"

    if [ -r "$file" ]
    then
        echo "File is readable"
    else
        echo "File is not readable"
    fi

    if [ -w "$file" ]
    then
        echo "File is writable"
    else
        echo "File is not writable"
    fi

else
    echo "File does not exist"
fi
