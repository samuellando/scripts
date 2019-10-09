#!/bin/sh
#
# Access the users password vault.
#
# Requires: 
#   - dmenu 
#   - notify-send 
#   - xclip 
#   - xdotool

cd ~/repos/pass
./decrypt
# If the decrytion fails.
if [ $? -ne 0 ]; then
	exit $?
fi

# Format in passwords file is: "name<s>url<u>userName<p>passwrod\n".
name=$(grep ".*<s>" -o passwords.txt | sed -e "s:<s>::g" | dmenu)
# if the user presses esc on dmenu.
if [ "$?" != 0 ]; then
	./encrypt
	exit
fi

info=$(grep "^$name<s>" passwords.txt)
./encrypt

url=$(echo $info | sed -e "s:.*<s>::g" | sed -e "s:<u>.*::g")
s=$(echo $info | sed -e "s:.*<u>::g" | sed -e "s:<p>.*::g")
p=$(echo $info | sed -e "s:.*<p>::g")

# If the user uses the --m flag
if [ "$1" = "--m" ]; then
	printf "%s" $s | xclip -selection clipboard -i
	notify-send "pass" "Username coppied to clipboard"
	sleep 5
        printf "%s" $p | xclip -selection clipboard -i
        notify-send "pass" "Password coppied to clipboard"
        sleep 5
        printf "" | xclip -selection clipboard -i
        exit
fi
xdotool type $s
xdotool key Tab
xdotool type $p
