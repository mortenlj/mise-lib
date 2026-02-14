ARG PY_VERSION=3
FROM python:${PY_VERSION}-slim AS docker
WORKDIR /app

# Load built virtualenv
ONBUILD COPY --from=build /venv /app/.venv
# Retarget virtualenv to the python in this image
ONBUILD RUN ln --force --logical --symbolic --target-directory /app/.venv/bin /usr/local/bin/python*

# Set PATH putting virtualenv first
ENV PATH="/app/.venv/bin:/bin:/usr/bin:/usr/local/bin"
# Test that the virtualenv actually works
ONBUILD RUN python -c "import ibidem" ## Minimal testing that imports actually work

# Set a dummy entrypoint to help remember to override in downstream Dockerfile
ENTRYPOINT ["python", "-c", "print('TODO: Set ENTRYPOINT!')"]
