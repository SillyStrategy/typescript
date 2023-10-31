# https://github.com/devcontainers/images/tree/main/src/typescript-node

ARG NODE_VARIANT=20
ARG DOCKER_COMPOSE_VERSION
ARG CODE_SERVER_VERSION

FROM mcr.microsoft.com/devcontainers/typescript-node:${NODE_VARIANT}

# install basic tools & dependencies
RUN echo "***** INSTALLING TOOLS AND DEPENDENCIES *****" \
    && apt-get update \
    && apt-get install -y \
    curl \
    jq \
    git \
    libatomic1 \
    net-tools \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    lsb-release \
    sudo

# # install docker ce cli
# RUN echo "***** INSTALLING DOCKER CE CLI *****" \
#     && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
#     && echo "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /​etc​/apt/sources.list.d/docker.list \
#     && apt-get update \
#     && apt-get install -y \
#     docker-ce-cli

# # install docker compose
# RUN echo "***** INSTALLING DOCKER COMPOSE *****" \
#     && DOCKER_COMPOSE_VERSION=$(curl -sSL "https://api.github.com/repos/docker/compose/releases/latest" | grep -o -P '(?<="tag_name": ").+(?=")') \
#     && curl -sSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
#     && chmod +x /usr/local/bin/docker-compose

# install code-server
RUN echo "***** INSTALLING CODE-SERVER *****" \
    CODE_SERVER_VERSION=$(curl -sX GET https://api.github.com/repos/coder/code-server/releases/latest | awk '/tag_name/{print $4;exit}' FS='[""]' | sed 's|^v||'); \
    && mkdir -p /app/code-server \
    && curl -o /tmp/code-server.tar.gz -L "https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server-${CODE_SERVER_VERSION}-linux-amd64.tar.gz" \
    && tar xf /tmp/code-server.tar.gz -C /app/code-server --strip-components=1

# cleanup
RUN echo "***** CLEANING UP *****" \
    && apt-get clean \
    && rm -rf \
    /config/* \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# ports and volumes
EXPOSE 8443