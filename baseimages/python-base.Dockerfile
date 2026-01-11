FROM jdxcode/mise:latest
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_PYTHON_DOWNLOADS=0
ENV UV_NO_EDITABLE=1
WORKDIR /app

# Pre-install lots of tools
COPY mise.toml ./mise.toml
RUN --mount=type=cache,target=/root/.cache/mise \
    mise trust -a && mise install
