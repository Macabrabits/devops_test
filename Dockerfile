# https://courses.devopsdirective.com/docker-beginner-to-pro/lessons/06-building-container-images/02-api-node-dockerfile
ARG NODE_VERSION=20.11.1
ARG NPM_VERSION=10.7.0

###########################################################################
###########################################################################

FROM docker.io/node:${NODE_VERSION} AS base
ARG NPM_VERSION
ENV NPM_VERSION ${NPM_VERSION}
RUN set -eu; \
    \
# Install pinned version of npm, regardless of node version, for stability
    npm install -g npm@${NPM_VERSION} @nestjs/cli  ; \
# Install busybox for several Unix utilities
# and tini to act as our simple init
    apt-get update && apt-get upgrade --no-install-recommends -y \
        busybox-static \
        tini \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# Using rootless user for better security
USER node
# Add node_modules location to PATH
ENV PATH /app/node_modules/.bin:$PATH
WORKDIR /app
# Copy package.json and lock for reproducible dependencies install
COPY --chown=node:node package.json package-lock.json* ./
# Using tini as PID 1 and kernel signals handler
ENTRYPOINT ["/usr/bin/tini", "--"]
EXPOSE 3000

###########################################################################
###########################################################################

FROM base AS development
ENV NODE_ENV=development
# Install ps util for nodemon hot reload
# https://github.com/remy/nodemon/issues/454#issuecomment-68740175
USER root
RUN apt-get update && apt-get install --no-install-recommends -y \
        procps \
        && apt-get clean
USER node
CMD [ "/bin/sh", "-c", "[ ! -d node_modules ] && npm install --development ; npm run start:dev" ]
# CMD ["npm", "run", "start:dev"]

###########################################################################
###########################################################################

FROM base AS node_builder
# Install production only dependencies
# npm ci is used for creating reproducible environments
RUN npm ci --production

###########################################################################
###########################################################################

FROM node_builder AS nest_builder
# Install devDependencies
RUN npm install
# Copy source code to container
COPY --chown=node:node . .
# Build nest project
RUN npm run build

###########################################################################
###########################################################################

FROM nest_builder AS test
CMD [ "npm", "run", "test:cov" ]

FROM docker.io/node:${NODE_VERSION}-slim AS production
ENV NODE_ENV=production
COPY --from=node_builder --chown=node:node /app/node_modules ./node_modules
COPY --from=node_builder --chown=node:node /app/package.json /app/package-lock.json* ./
COPY --from=nest_builder --chown=node:node /app/dist ./dist
CMD [ "npm", "run", "start:prod" ]