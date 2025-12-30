FROM jdxcode/mise:latest AS build
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV UV_PYTHON_DOWNLOADS=0
ENV UV_NO_EDITABLE=1
WORKDIR /app
ONBUILD COPY .config ./.config/
ONBUILD COPY mise.toml ./mise.toml
ONBUILD RUN mise trust -a && mise install
ONBUILD COPY pyproject.toml uv.lock ./
ONBUILD RUN --mount=type=cache,target=/root/.cache/uv \
	        uv sync --locked --no-install-project
ONBUILD COPY ibidem/ ./ibidem/
ONBUILD COPY tests/ ./tests/
ONBUILD RUN --mount=type=cache,target=/root/.cache/uv \
	        uv sync --locked
ONBUILD RUN mise run ci
ONBUILD ENV UV_NO_DEV=1
ONBUILD RUN --mount=type=cache,target=/root/.cache/uv \
	        uv sync --locked
