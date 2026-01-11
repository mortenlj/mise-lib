FROM ghcr.io/mortenlj/mise-lib/rust-base:latest AS build

# Load downstream mise config and run install with that config
ONBUILD COPY .config/mise-lib ./.config/mise-lib
ONBUILD COPY mise.toml ./mise.toml
ONBUILD RUN --mount=type=cache,target=/root/.cache/mise \
            mise trust -a &&  \
            mise install

# Run downstream ci tasks
ONBUILD RUN --mount=type=cache,target=/root/.cargo/registry \
            --mount=type=bind,target=/app,rw \
            --mount=type=cache,target=/app/target \
            mise run ci

# Load downstream sources and build project
# When complete, copy binaries to a location where it's easier for the downstream image to find them because docker and rust are not friends
ONBUILD ARG binary_name
ONBUILD RUN --mount=type=cache,target=/root/.cargo/registry \
            --mount=type=bind,target=/app,rw \
            --mount=type=cache,target=/app/target \
	        mise run release-build && \
            mkdir --parents /bin/{arm64,amd64,arm}/ && \
            cp -v /app/target/release/${binary_name}.*.aarch64-unknown-linux-gnu /bin/arm64/${binary_name} && \
            cp -v /app/target/release/${binary_name}.*.x86_64-unknown-linux-gnu /bin/amd64/${binary_name} && \
            cp -v /app/target/release/${binary_name}.*.armv7-unknown-linux-gnueabihf /bin/arm/${binary_name}
