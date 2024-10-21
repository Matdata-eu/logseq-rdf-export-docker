ARG LOGSEQ_RDF_EXPORT_VERSION=0.2.0
ARG OPENJDK_VERSION=24-slim-bullseye
ARG NODE_MAJOR=20 

FROM openjdk:${OPENJDK_VERSION}

ARG LOGSEQ_RDF_EXPORT_VERSION
ARG NODE_MAJOR

# Install Clojure & Babashka
RUN apt update && apt remove -y cmdtest && apt install -y npm curl ca-certificates gnupg && \
    curl -L -O https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh && chmod +x linux-install.sh && ./linux-install.sh && \
    ["/bin/bash", "-c", "bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)"]

# Install Node.js
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt update && apt install nodejs wget -y

WORKDIR /logseq-rdf-export

# Install logseq-rdf-export
RUN wget https://github.com/logseq/rdf-export/archive/refs/tags/v${LOGSEQ_RDF_EXPORT_VERSION}.tar.gz && \
    tar -axvf *.tar.gz --directory /logseq-rdf-export --strip-components=1 && \
    rm *.tar.gz && \
    npm install -g yarn && \
    yarn install && \
    yarn global add /logseq-rdf-export && \
    logseq-rdf-export || true

WORKDIR /data