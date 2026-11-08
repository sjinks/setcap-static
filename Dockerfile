FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS build
RUN apk add --no-cache cmake make musl-dev gcc libcap-static libcap-dev
WORKDIR /build
COPY . .
RUN \
    cmake -S . -B build -DCMAKE_BUILD_TYPE=MinSizeRel && \
    cmake --build build --config MinSizeRel && \
    strip build/setcap-static

FROM scratch
COPY --from=build /build/build/setcap-static /setcap-static
