# ---------- Build Stage (.NET + Node) ----------
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Node.jsをインストール
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

WORKDIR /workspaces

# 依存関係をコピーして復元
COPY *.csproj .
RUN dotnet restore

# ソースをコピーしてフロントエンドビルド
COPY . .
WORKDIR /workspaces/src
RUN npm install
RUN npm run build

# .NET アプリをパブリッシュ
WORKDIR /workspaces
RUN dotnet publish -c Release -o /app/publish

# ---------- Runtime Stage (.NET) ----------
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "HubFootball.dll"]