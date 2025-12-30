FROM python:3.11-slim AS docker
WORKDIR /app
ONBUILD COPY --from=build /app/.venv/ ./.venv/
ONBUILD RUN ln --force --logical --symbolic --target-directory /app/.venv/bin /usr/local/bin/python*
ENV PATH="/app/.venv/bin:/bin:/usr/bin:/usr/local/bin"
ONBUILD RUN python -c "import ibidem" ## Minimal testing that imports actually work
ENTRYPOINT ["python", "-c", "print('TODO: Set ENTRYPOINT!')"]
