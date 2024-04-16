#!/bin/bash
#Fichier prêté par Yohan Cardis pour la compréhension de la config


# Mise à jour des paquets
sudo apt update

# Installation des dépendances
sudo apt install -y wget apt-transport-https software-properties-common

# Téléchargement du package Microsoft
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

# Mise à jour des paquets après l'installation du package Microsoft
sudo apt update

# Vérification de l'installation de la version 8 de .NET Core et du runtime ASP.NET Core
dotnet_version=$(dotnet --version)
if [[ $dotnet_version != *"8."* ]]; then
    # Installation de l'environnement ASP.NET Core
    sudo apt install -y aspnetcore-runtime-8.0
fi

dotnet_sdk_version=$(dotnet --list-sdks | grep "2.1.8" -c)
if [ "$dotnet_sdk_version" -eq 0 ]; then
    # Installation du SDK .NET Core
    sudo apt install -y dotnet-sdk-8.0
fi

cd bin/Debug/net8.0

# Recherche du fichier .dll dans le répertoire net8.0
dll_file=$(find . -name "*.dll")

if [ -z "$dll_file" ]; then
    echo "Aucun fichier .dll trouvé dans le répertoire net8.0"
    exit 1
fi

# Lancement de l'application
dotnet "$dll_file"
