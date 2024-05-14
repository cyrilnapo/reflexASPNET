#!/bin/bash
cd ../
# Mise à jour et installation des dépendances
sudo apt update
sudo apt install -y wget apt-transport-https software-properties-common

# Téléchargement et installation du package Microsoft
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update

# Installation de l'ASP.NET Core Runtime 6.0
sudo apt install -y aspnetcore-runtime-6.0

# Mise à jour du système
sudo apt upgrade
sudo apt update

# Installation du SDK .NET 6.0
sudo apt install -y dotnet-sdk-6.0


cd launch_project/

echo "Commencement de la création des containers de base de donnée"
docker compose up -d

success=false

while [ $success = false ]; do
  # Execute the command
    read -p "Veuillez entrer le nom du nouveau réseau Docker sur lequel sera lié vos containers: " network_name
    docker network create $network_name

  # Check the exit code of the command
  if [ $? -eq 0 ]; then
    # The command was successful
    success=true
  fi
done

# Demander le nom du conteneur dev environment
read -p "Veuillez entrer le nom du conteneur Docker à lier (container dev environment) : " container


# Lier les conteneurs au réseau
docker network connect $network_name $container
docker network connect $network_name db


echo "Le conteneur $container et les containers de db ont été liés au réseau $network_name avec succès."
echo "Ils peuvent maintenant communiqué entre eux."


echo "lancement du fichier .dll..."
# Déplacement vers le répertoire contenant le fichier .dll
cd ../bin/Debug/net6.0

# Recherche du fichier .dll
dll_file=$(find . -name "*.dll")

# Vérification si le fichier .dll a été trouvé
if [ -z "$dll_file" ]; then
    echo "Aucun fichier .dll trouvé dans le répertoire net6.0"
    exit 1
fi

# Lancement de l'application
dotnet "$dll_file"

