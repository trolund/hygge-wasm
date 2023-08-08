FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["run/run.fsproj", "run/"]
RUN dotnet restore "run/run.fsproj"
COPY . .
WORKDIR "/src/run"
RUN dotnet build "run.fsproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "run.fsproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "run.dll"]
