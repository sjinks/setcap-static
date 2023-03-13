FROM alpine:3.17.2@sha256:ff6bdca1701f3a8a67e328815ff2346b0e4067d32ec36b7992c1fdc001dc8517 AS build
RUN apk add --no-cache cmake make musl-dev gcc libcap-static libcap-dev
WORKDIR /build
COPY . .
RUN \
    cmake -S . -B build -DCMAKE_BUILD_TYPE=MinSizeRel && \
    cmake --build build --config MinSizeRel && \
    strip build/setcap-static

FROM scratch
COPY --from=build /build/build/setcap-static /setcap-static
