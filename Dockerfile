FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build-env
WORKDIR /app
# Copy csproj and restore as distinct layers
COPY . ./
#RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out
COPY ClientModels/. /app/out/ClientModels/.
COPY SpModels/. /app/out/SpModels/.
COPY Keys/. /app/out/Keys/.

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim
WORKDIR /app
COPY --from=build-env /app/out .
ENV QHIREAPI_ClientModelFolder=/app/ClientModels
ENV QHIREAPI_EncryptionKeysFolder=/app/Keys
ENV QHIREAPI_SpModelFolder=/app/SpModels
ENTRYPOINT ["dotnet", "QHireAPI.dll"]
