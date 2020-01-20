#!/bin/bash

function get_keyboard_layout()
{
	case "$(xset -q|grep LED| awk '{ print $10 }')" in
	  "00000000") echo "En" ;;
	  "00001004") echo "Ru" ;;
	  *) echo "unknown" ;;
	esac
}

get_keyboard_layout
