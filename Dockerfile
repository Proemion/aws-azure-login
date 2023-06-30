FROM node:20-slim AS node_base

# Install Puppeteer dependencies: https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#chrome-headless-doesnt-launch
RUN apt-get update \
   && apt-get install -y \
   gconf-service \
   libasound2 \
   libatk1.0-0 \
   libc6 \
   libcairo2 \
   libcups2 \
   libdbus-1-3 \
   libexpat1 \
   libfontconfig1 \
   libgcc1 \
   libgconf-2-4 \
   libgdk-pixbuf2.0-0 \
   libglib2.0-0 \
   libgtk-3-0 \
   libnspr4 \
   libpango-1.0-0 \
   libpangocairo-1.0-0 \
   libstdc++6 \
   libx11-6 \
   libx11-xcb1 \
   libxcb1 \
   libxcomposite1 \
   libxcursor1 \
   libxdamage1 \
   libxext6 \
   libxfixes3 \
   libxi6 \
   libxrandr2 \
   libxrender1 \
   libxss1 \
   libxtst6 \
   ca-certificates \
   fonts-liberation \
   libappindicator1 \
   libnss3 \
   lsb-release \
   xdg-utils \
   wget \
   && apt-get -q -y clean \
   && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Build the repo itself as part of the Docker build
FROM node_base AS repo_build
COPY . /aws-azure-login/
WORKDIR /aws-azure-login
RUN yarn install && yarn build

# Install the production version to the end image and copy the locally built stuff from BUILD
FROM node_base
COPY package.json yarn.lock /aws-azure-login/
WORKDIR /aws-azure-login
RUN yarn install --production
COPY --from=repo_build /aws-azure-login/lib /aws-azure-login/lib

ENTRYPOINT ["node", "/aws-azure-login/lib", "--no-sandbox"]
