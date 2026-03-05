FROM ghcr.io/openclaw/openclaw:latest

# Add additional tools and dependencies
ENV MISE_DATA_DIR="/tools"
ENV MISE_CONFIG_DIR="/tools/config"
ENV MISE_CACHE_DIR="/tools/cache"
ENV PATH="/tools/shims:/tools/bin:${PATH}"

USER root

# System tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git openssh-client bash gosu \
    && rm -rf /var/lib/apt/lists/*

# Install Tailscale
ARG TAILSCALE_VERSION=1.94.1
ENV TAILSCALE_VERSION=${TAILSCALE_VERSION}
RUN curl -fsSL https://tailscale.com/install.sh | sh

# notesmd-cli
ARG NOTESMD_VERSION=0.3.1
RUN curl -fsSL https://github.com/Yakitrak/notesmd-cli/releases/download/v${NOTESMD_VERSION}/notesmd-cli_${NOTESMD_VERSION}_linux_amd64.tar.gz \
    | tar -xz -C /usr/local/bin notesmd-cli

# d2 (text-to-diagram)
ARG D2_VERSION=0.7.1
RUN curl -fsSL https://github.com/terrastruct/d2/releases/download/v${D2_VERSION}/d2-v${D2_VERSION}-linux-amd64.tar.gz \
    | tar -xz --strip-components=2 -C /usr/local/bin d2-v${D2_VERSION}/bin/d2

# marp (markdown presentations)
ARG MARP_VERSION=4.2.3
RUN curl -fsSL https://github.com/marp-team/marp-cli/releases/download/v${MARP_VERSION}/marp-cli-v${MARP_VERSION}-linux.tar.gz \
    | tar -xz -C /usr/local/bin marp

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
