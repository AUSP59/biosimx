# syntax=docker/dockerfile:1
FROM ubuntu:24.04 AS build
RUN apt-get update && apt-get install -y cmake ninja-build g++ git
WORKDIR /src
COPY . .
RUN cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release && cmake --build build -j

FROM gcr.io/distroless/cc AS runtime
LABEL org.opencontainers.image.title="BioSimX" \
      org.opencontainers.image.description="Deterministic C++ biosimulation engine" \
      org.opencontainers.image.source="https://example.org/biosimx" \
      org.opencontainers.image.licenses="MIT"
COPY --from=build /src/build/bin/biosimx /usr/local/bin/biosimx
USER 65532:65532
ENTRYPOINT ["/usr/local/bin/biosimx"]
