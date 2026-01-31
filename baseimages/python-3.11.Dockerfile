FROM python:3.14-slim@sha256:9b81fe9acff79e61affb44aaf3b6ff234392e8ca477cb86c9f7fd11732ce9b6a AS docker
WORKDIR /app

# Load built virtualenv
ONBUILD COPY --from=build /app/.venv/ ./.venv/
# Retarget virtualenv to the python in this image
ONBUILD RUN ln --force --logical --symbolic --target-directory /app/.venv/bin /usr/local/bin/python*

# Set PATH putting virtualenv first
ENV PATH="/app/.venv/bin:/bin:/usr/bin:/usr/local/bin"
# Test that the virtualenv actually works
ONBUILD RUN python -c "import ibidem" ## Minimal testing that imports actually work

# Set a dummy entrypoint to help remember to override in downstream Dockerfile
ENTRYPOINT ["python", "-c", "print('TODO: Set ENTRYPOINT!')"]
