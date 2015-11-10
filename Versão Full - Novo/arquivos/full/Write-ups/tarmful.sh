#!/bin/bash

for ((i=1023; i>=0; i--))
	do
		path=`find . -name $i`

		cp $path/* ./troca/
		rm -rf $path

		mv ./troca/* .

		7z x -y $i*
		
		if [ -e $i.tar ]
		then
			tar -xvf $i.tar
		fi

		counter=$((counter+1))
		echo $counter
	done

