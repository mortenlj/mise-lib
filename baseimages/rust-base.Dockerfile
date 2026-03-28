FROM ghcr.io/mortenlj/mise-lib/base:latest AS base

# Pre-install lots of tools
RUN --mount=type=cache,target=/root/.cache/mise \
    --mount=type=bind,target=/app \
    mise run rust:setup
