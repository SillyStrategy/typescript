FROM lscr.io/linuxserver/code-server:latest

# install basic tools & dependencies
RUN \
    && apt-get update \
    && apt-get install -y \
    nodejs \
    npm

# ports and volumes
EXPOSE 8443