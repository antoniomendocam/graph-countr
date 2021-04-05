#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ./src/Mutant.Galileo.Api/Mutant.Galileo.Api.csproj /src/Mutant.Galileo.Api/
COPY ./src/Mutant.Galileo.Domain/Mutant.Galileo.Domain.csproj /src/Mutant.Galileo.Domain/

WORKDIR /src/Mutant.Galileo.Api/
RUN dotnet restore "Mutant.Galileo.Api.csproj"

WORKDIR /src
COPY ./src .
WORKDIR /src/Mutant.Galileo.Api/
RUN dotnet build "Mutant.Galileo.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Mutant.Galileo.Api.csproj" -c Release -o /app/publish

FROM base AS final
ENV TZ "America/Sao_Paulo"
ENV LANG "pt_BR.UTF-8"
ENV LANGUAGE "pt_BR:pt"
ENV LC_ALL ${LANG}
WORKDIR /app
COPY --from=publish /app/publish .
CMD [ "dotnet", "Mutant.Galileo.Api.dll" ]