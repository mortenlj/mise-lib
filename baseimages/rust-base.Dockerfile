FROM jdxcode/mise:latest
WORKDIR /app

ENV RUSTFLAGS="-C target-feature=+crt-static"

# Pre-install lots of tools
RUN --mount=type=cache,target=/root/.cache/mise \
    --mount=type=bind,target=/app \
    mise trust -a && \
    mise install && \
    mise run rust:setup
