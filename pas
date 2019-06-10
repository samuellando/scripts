#!/bin/sh
#
# Access the users password vault.
# Requires: dmenu, notify-send, xclip
#

cd ~/repos/pass
./decrypt
if [ $? -ne 0 ]; then
	exit $?
fi
name=$(grep ".*<s>" -o passwords.txt | sed -e "s:<s>::g" | dmenu)
if [ "$?" != 0 ]; then
	./encrypt
	exit
fi
info=$(grep "^$name<s>" passwords.txt)
./encrypt
url=$(echo $info | sed -e "s:.*<s>::g" | sed -e "s:<u>.*::g")
s=$(echo $info | sed -e "s:.*<u>::g" | sed -e "s:<p>.*::g")
p=$(echo $info | sed -e "s:.*<p>::g")
if [ "$#" -ne 0 ]; then
	echo $url
	exit
fi
printf "%s" $s | xclip -selection clipboard -i
notify-send "pass" "Username coppied to clipboard"
sleep 5
printf "%s" $p | xclip -selection clipboard -i
notify-send "pass" "Password coppied to clipboard"
sleep 5
printf "" | xclip -selection clipboard -i
