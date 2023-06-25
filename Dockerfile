FROM alpine:3.18.2@sha256:82d1e9d7ed48a7523bdebc18cf6290bdb97b82302a8a9c27d4fe885949ea94d1 AS build
RUN apk add --no-cache cmake make musl-dev gcc libcap-static libcap-dev
WORKDIR /build
COPY . .
RUN \
    cmake -S . -B build -DCMAKE_BUILD_TYPE=MinSizeRel && \
    cmake --build build --config MinSizeRel && \
    strip build/setcap-static

FROM scratch
COPY --from=build /build/build/setcap-static /setcap-static
