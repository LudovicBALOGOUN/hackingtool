# syntax=docker/dockerfile:1
FROM kalilinux/kali-rolling:latest

LABEL org.opencontainers.image.title="hackingtool" \
      org.opencontainers.image.description="All-in-One Hacking Tool for Security Researchers" \
      org.opencontainers.image.source="https://github.com/Z4nzu/hackingtool" \
      org.opencontainers.image.licenses="MIT"

# Runtime system deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git python3 python3-pip python3-venv curl wget php && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY pyproject.toml README.md ./
COPY src ./src

RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install --break-system-packages .

# Tools install their payloads at runtime under here; persist via a volume.
RUN mkdir -p /root/.hackingtool/tools
WORKDIR /root

# Garde le conteneur actif sans lancer l'outil automatiquement
CMD ["tail", "-f", "/dev/null"]
