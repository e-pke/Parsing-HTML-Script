#!/bin/bash
if [ "$1" == "" 2>/dev/null ]
then
	echo -e "\033[1;31m   >>>>> USO CORRETO: ./parsing.sh <url>"
else
	echo -e "\033[1;32m   >>>>> ACESSANDO PÁGINA"
	echo -e "\033[1;37m "
	wget $1 2>/dev/null
	echo -e "\033[1;34m   >>>>> BUSCANDO HOSTS NA PÁGINA" "\033[1;37m "
	grep href index.html | grep http | cut -d "/" -f3 | cut -d '"' -f1  | grep "\." | grep -v " "> lista
	cat lista
	echo -e "\033[1;37m "
	echo -e "\033[1;34m   >>>>> RESOLVENDO HOSTS ENCONTRADOS" "\033[1;37m "
	for url in $(cat lista); do host $url | grep " has address " >> hosts; done
	sed -i 's/ has address /=/g' hosts
	cat hosts | uniq > hosts_$1
	cat hosts_$1
	echo -e "\033[1;37m "
	echo -e "\033[1;33m   >>>>> PRONTO!" "\033[1;32m "
	echo " "
	rm hosts
	rm index.html
	rm lista
	read -p "   >>>>> DESEJA FAZER NOVAMENTE? [y/n] " answer
	if [ "$answer" != "y" ]
	then
		echo -e "\033[1;31m   >>>>> ENCERRADO!" "\033[1;37m "
	else
		read -p "   >>>>> DIGITE A NOVA URL:  " alvo
		echo " "
		./$0 $alvo
	fi
fi
