FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c AS build
RUN apk add --no-cache cmake make musl-dev gcc libcap-static libcap-dev
WORKDIR /build
COPY . .
RUN \
    cmake -S . -B build -DCMAKE_BUILD_TYPE=MinSizeRel && \
    cmake --build build --config MinSizeRel && \
    strip build/setcap-static

FROM scratch
COPY --from=build /build/build/setcap-static /setcap-static
