# ---------- Build Stage (.NET + Node) ----------
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# 依存関係をコピーして復元
COPY *.csproj .
RUN dotnet restore

# ソースをコピーしてフロントエンドビルド
COPY . .
WORKDIR /src/ClientApp
RUN npm install
RUN npm run build

# .NET アプリをパブリッシュ
WORKDIR /src
RUN dotnet publish -c Release -o /app/publish

# ---------- Runtime Stage (.NET) ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "HubFootball.dll"]