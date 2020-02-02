#!/bin/bash

function get_keyboard_layout()
{
    if [ "$(xset -q|grep LED| awk '{ print $10 }')" -lt "00001004" ]
    then
	 echo "En";
    else
	  echo "Ru";
    fi
}

get_keyboard_layout
