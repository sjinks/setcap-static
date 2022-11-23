FROM alpine:3.17.0@sha256:8914eb54f968791faf6a8638949e480fef81e697984fba772b3976835194c6d4 AS build
RUN apk add --no-cache cmake make musl-dev gcc libcap-static libcap-dev
WORKDIR /build
COPY . .
RUN \
    cmake -S . -B build -DCMAKE_BUILD_TYPE=MinSizeRel && \
    cmake --build build --config MinSizeRel && \
    strip build/setcap-static

FROM scratch
COPY --from=build /build/build/setcap-static /setcap-static
