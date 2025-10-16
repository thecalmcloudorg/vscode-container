FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
      curl \
      wget \
      unzip \
      git \
      nano \
      python3 \
      python3-pip \
      python3-venv \
      software-properties-common \
      gnupg2 \
      lsb-release \
      openssh-client

# Node.js (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# Terraform
RUN wget https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip && \
    unzip terraform_1.8.5_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.8.5_linux_amd64.zip

# Terragrunt
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.56.7/terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Ansible
RUN apt-get update && \
    apt-get install -y ansible

# Black (Python formatter)
RUN pip3 install --upgrade pip && pip3 install black

# Crea usuario vscode
RUN useradd -ms /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER vscode
WORKDIR /home/vscode

# Copia el commit template al home de vscode
COPY .gitcommittemplate /home/vscode/.gitcommittemplate

# Script de configuración inicial para usuario vscode
RUN echo '#!/bin/bash\n\
if [ ! -f ~/.ssh/id_rsa ]; then\n\
  mkdir -p ~/.ssh\n\
  ssh-keygen -t rsa -b 4096 -C "vscode@devcontainer" -N "" -f ~/.ssh/id_rsa\n\
  eval "$(ssh-agent -s)"\n\
  ssh-add ~/.ssh/id_rsa\n\
  echo "SSH key generated in ~/.ssh/id_rsa"\n\
fi\n\
git config --global user.name "VSCode Dev"\n\
git config --global user.email "vscode@devcontainer"\n\
git config --global commit.template ~/.gitcommittemplate\n\
' > /home/vscode/bootstrap.sh && \
    chmod +x /home/vscode/bootstrap.sh && \
    echo "[ -f ~/bootstrap.sh ] && bash ~/bootstrap.sh" >> /home/vscode/.bashrc
