# Stage 1: Build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project file and restore
COPY *.csproj ./
RUN dotnet restore

# Copy the rest and publish
COPY . ./
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Set the environment to bind to port 80
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

# Copy published output
COPY --from=build /app/publish .

# Run the app
ENTRYPOINT ["dotnet", "WebApiProject.dll"]
