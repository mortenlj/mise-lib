FROM jdxcode/mise:latest
WORKDIR /app

# Pre-install lots of tools
RUN --mount=type=cache,target=/root/.cache/mise \
    --mount=type=bind,target=/app \
    mise trust -a && \
    mise install
