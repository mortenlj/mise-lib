FROM cgr.dev/chainguard/static:latest

ONBUILD ARG TARGETARCH
ONBUILD ARG binary_name
ONBUILD COPY --from=build /bin/$TARGETARCH/$binary_name /usr/bin/$binary_name

USER 65532:65532

# Set a dummy entrypoint to help remember to override in downstream Dockerfile
CMD ["TODO: Set ENTRYPOINT!"]
