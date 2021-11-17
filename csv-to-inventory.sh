#!/bin/bash


input="./stormshield-database.csv"
output="./inventory.yaml.auto"

# CSV file :
# name;subname;host;port;user;password

# example :
# ENTREPRISE;EMPLACEMENT;server.entreprise.com;443;admin;password

# Les champs 1 et 2 définiront le nom du parefeu sur ansible : ENTREPRISE_EMPLACEMENT

# ---

i=0
echo "sns_appliances:" > $output
echo "  hosts:" >> $output

while IFS= read -r line
do
	let "i=i+1"
	line=`echo $line | tr ' ' '_' | tr "'" '_'`
	name=`echo "$line" | cut -d";" -f 1-2 | tr ';' '_'`
	if [ "${name: -1}" == "_" ]; then
		name="${name::-1}"
	fi
	host=`echo "$line" | cut -d";" -f 3`
	port=`echo "$line" | cut -d";" -f 4`
	user=`echo "$line" | cut -d";" -f 5`
	password=`echo "$line" | cut -d";" -f 6`

	echo $name
	#echo $name:$host:$port:$user:$password

	echo "    $name:" >> $output
	echo "      appliance:" >> $output
	echo "        host: $host" >> $output
	echo "        port: $port" >> $output
	echo "        user: $user" >> $output
	echo "        password: \"$password\"" >> $output
	echo "        sslverifyhost: false" >> $output
	echo "        sslverifypeer: false" >> $output


done < "$input"
echo "Nombre d'appliance" : $i

# A activer pour copier dans le répertoire par défaut d'Ansible
# cp $output /etc/ansible/hosts
