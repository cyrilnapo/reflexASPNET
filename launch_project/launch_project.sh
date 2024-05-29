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

# Se place dans le dossier où est le script
cd launch_project/

echo "Commencement de la création des containers de base de donnée"
docker compose up -d

success=false

# Créer un network
while [ $success = false ]; do
    read -p "Veuillez entrer le nom du nouveau réseau Docker sur lequel sera lié vos containers: " network_name
    docker network create $network_name

  if [ $? -eq 0 ]; then
    success=true
  fi
done

success=false

# Lie le container du projet à la db
while [ $success = false ]; do
  read -p "Veuillez entrer l'id du conteneur Docker à lier (container DEV ENVIRONMENT !) : " container
  docker network connect $network_name $container

  if [ $? -eq 0 ]; then
    success=true
  fi
done

docker network connect $network_name db


echo "Le conteneur $container et les containers de db ont été liés au réseau $network_name avec succès."
echo "Ils peuvent maintenant communiqué entre eux."


echo "lancement du fichier .dll..."

# Déplacement vers le répertoire contenant le fichier .dll
cd ../bin/Debug/net6.0

# Recherche du fichier .dll
dll_file=$(find . -name "Reflex_Project.dll")

# Vérification si le fichier .dll a été trouvé
if [ -z "$dll_file" ]; then
    echo "Aucun fichier .dll trouvé dans le répertoire net6.0"
    exit 1
fi

# Lancement de l'application
dotnet "$dll_file"