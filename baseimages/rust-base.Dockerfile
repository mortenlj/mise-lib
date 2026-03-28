FROM ghcr.io/mortenlj/mise-lib/base:latest AS base

# Pre-install lots of tools
RUN mise run rust:setup
