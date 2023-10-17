FROM ghcr.io/linuxserver/baseimage-alpine:edge AS builder
WORKDIR /app
COPY requirements.txt .
COPY install_dependencies.sh .
RUN apk add --update --no-cache py3-pip py3-setuptools python3 python3-dev py3-virtualenv \
    && python3 -m venv .venv \
    && .venv/bin/pip install --no-cache-dir -r requirements.txt \
    && bash install_dependencies.sh

FROM ghcr.io/linuxserver/baseimage-alpine:edge

WORKDIR /app

RUN apk add --update --no-cache python3

COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/ffmpeg /app/ffmpeg
COPY xiaomusic/ ./xiaomusic/
COPY xiaomusic.py .
VOLUME /config
EXPOSE 8090
ENV PATH=/app/.venv/bin:$PATH
ENTRYPOINT [".venv/bin/python3","xiaomusic.py"]
