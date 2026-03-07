FROM ghcr.io/mortenlj/mise-lib/python-base:latest AS build

# Load downstream mise config and project files and run install with that config
ONBUILD COPY .config ./.config/
ONBUILD COPY mise.toml pyproject.toml uv.lock ./
ONBUILD RUN --mount=type=cache,target=/root/.cache/mise \
            mise trust -a && mise install

ONBUILD ARG MORTENLJ_MISE_LIB_CLEAN_VERSION=0.0.0+develop
ONBUILD ENV UV_DYNAMIC_VERSIONING_BYPASS=${MORTENLJ_MISE_LIB_CLEAN_VERSION}

# Install dependencies
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

ONBUILD RUN ${UV_PROJECT_ENVIRONMENT}/bin/python -c "import ibidem" ## Minimal testing that imports actually work
