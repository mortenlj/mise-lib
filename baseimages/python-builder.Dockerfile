FROM ghcr.io/mortenlj/mise-lib/python-base:latest AS build

# Load downstream mise config and run install with that config
ONBUILD COPY .config ./.config/
ONBUILD COPY mise.toml ./mise.toml
ONBUILD RUN --mount=type=cache,target=/root/.cache/mise \
            mise trust -a && mise install

# Load downstream project files and install dependencies
ONBUILD COPY pyproject.toml uv.lock ./
ONBUILD RUN --mount=type=cache,target=/root/.cache/uv \
	        uv sync --locked --no-install-project

# Load downstream sources and install project
ONBUILD RUN --mount=type=cache,target=/root/.cache/uv \
            --mount=type=bind,target=/app,rw \
            uv sync --locked

# Run downstream ci tasks
ONBUILD RUN --mount=type=bind,target=/app,rw \
            mise run ci

# Remove dev dependencies
ONBUILD ENV UV_NO_DEV=1
ONBUILD RUN --mount=type=cache,target=/root/.cache/uv \
	        --mount=type=bind,target=/app,rw \
            uv sync --locked
