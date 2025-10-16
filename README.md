Usage:

- docker build -t vscode-container https://github.com/thecalmcloudorg/vscode-container.git#main:.devcontainer
- docker run -d --name vscode-container --restart unless-stopped vscode-container tail -f /dev/null
