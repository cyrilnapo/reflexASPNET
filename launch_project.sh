#!/bin/bash

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

# Déplacement vers le répertoire contenant le fichier .dll
cd bin/Debug/net6.0

# Recherche du fichier .dll
dll_file=$(find . -name "*.dll")

# Vérification si le fichier .dll a été trouvé
if [ -z "$dll_file" ]; then
    echo "Aucun fichier .dll trouvé dans le répertoire net6.0"
    exit 1
fi

# Lancement de l'application
dotnet "$dll_file"