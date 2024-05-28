# Utilisez l'image de base appropriée
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build

# Définissez le répertoire de travail
WORKDIR /app

# Copiez les fichiers du projet principal
COPY src/ ./

# Copiez les fichiers du projet de tests unitaires
COPY tests/ ./tests/

# Exécutez les tests unitaires
RUN dotnet test tests/Reflex_Project.Tests.csproj
