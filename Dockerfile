# https://courses.devopsdirective.com/docker-beginner-to-pro/lessons/06-building-container-images/02-api-node-dockerfile
ARG NODE_VERSION=20.11.1
ARG NPM_VERSION=10.7.0

###########################################################################
###########################################################################

FROM docker.io/node:${NODE_VERSION} AS base
ARG NPM_VERSION
ENV NPM_VERSION ${NPM_VERSION}
RUN npm install -g npm@${NPM_VERSION} @nestjs/cli
USER node
WORKDIR /app
COPY --chown=node:node package*.json tsconfig.json ./

###########################################################################
###########################################################################

FROM base AS development
ENV NODE_ENV=development
RUN npm install --development
COPY --chown=node:node . .
CMD [ "/bin/sh", "-c", "[ ! -d node_modules ] && npm install --development ; npm run start:dev" ]
# CMD ["npm", "run", "start:dev"]

###########################################################################
###########################################################################

FROM base AS node_builder
# npm ci is used for creating reproducible environments
RUN npm ci --production

###########################################################################
###########################################################################

FROM development AS test
CMD [ "npm", "run", "test:cov" ]

###########################################################################
###########################################################################

FROM docker.io/node:${NODE_VERSION}-slim AS production
ENV NODE_ENV=production
COPY --from=node_builder --chown=node:node /app/node_modules ./node_modules
COPY --from=node_builder --chown=node:node /app/package.json /app/package-lock.json* ./
COPY --from=nest_builder --chown=node:node /app/dist ./dist
CMD [ "npm", "run", "start:prod" ]