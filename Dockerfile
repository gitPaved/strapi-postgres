FROM node:18-alpine

# Installer dépendances système
RUN apk update && apk add --no-cache \
  build-base \
  python3 \
  bash \
  vips-dev \
  git \
  autoconf \
  automake \
  libpng-dev \
  zlib-dev \
  nasm \
  libtool \
  make \
  g++

WORKDIR /opt/app

# Copier package.json et lock
COPY package*.json ./

# Installer les dépendances avec la bonne version d’esbuild
RUN npm install

# Copier le reste
COPY . .

# Changer le propriétaire pour l'utilisateur "node"
RUN chown -R node:node /opt/app
USER node

# Supprimer les binaires esbuild auto-générés avant le build
RUN rm -rf node_modules/esbuild/bin/* && npm run build

EXPOSE 1337
CMD ["npm", "run", "develop"]
