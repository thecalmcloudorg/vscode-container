FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV DEBIAN_FRONTEND=noninteractive

# Dependencias básicas
RUN apt-get update && apt-get install -y \
    git openssh-client curl gnupg lsb-release \
    unzip software-properties-common python3 python3-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Node.js (LTS 20.x)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y terraform \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Ansible
RUN add-apt-repository --yes --update ppa:ansible/ansible \
    && apt-get install -y ansible \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install \
    && rm -rf aws awscliv2.zip

# Configuración de usuario vscode
USER vscode
WORKDIR /workspaces
