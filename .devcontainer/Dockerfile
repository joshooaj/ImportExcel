FROM mcr.microsoft.com/powershell:lts-debian-11

SHELL [ "pwsh", "-NoLogo", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'; " ]
RUN apt update && apt install -y python3-pip mkdocs; \
    pip install mkdocs-material mkdocs-awesome-pages-plugin -q --no-input; \
    Install-Module Pester -RequiredVersion 5.5.0 -Force; \
    Install-Module psake -RequiredVersion 4.9.0 -Force; \
    Install-Module PSReadLine -RequiredVersion 2.3.4 -Force;