#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /graph-countries/graph-countries-back/src
COPY ./graph.countries.api.csproj ./graph-countries/src/graph.countries.api/
COPY ./graph.countries.domain.csproj ./graph-countries/src/graph.countries.domain/

WORKDIR /src
RUN dotnet restore "graph.countries.api.csproj"

WORKDIR /src
COPY ./src .
WORKDIR /src/graph.countries.api/
RUN dotnet build "graph.countries.api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "graph.countries.api.csproj" -c Release -o /app/publish

FROM base AS final
ENV TZ "America/Sao_Paulo"
ENV LANG "pt_BR.UTF-8"
ENV LANGUAGE "pt_BR:pt"
ENV LC_ALL ${LANG}
WORKDIR /app
COPY --from=publish /app/publish .
CMD [ "dotnet", "graph.countries.api.dll" ]