FROM alpine:latest

ARG PB_VERSION=0.25.2

ARG TARGET_OS
ARG TARGET_ARCH
ARG TARGET_VARIANT

ENV BUILDX_ARCH="${TARGET_OS:-linux}_${TARGET_ARCH:-amd64}${TARGET_VARIANT}"

RUN apk add --no-cache \
    unzip \
    ca-certificates

# download and unzip PocketBase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}${BUILDX_ARCH}.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/ \
    && chmod +x /pb/pocketbase \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

# uncomment to copy the local pb_migrations dir into the image
# COPY ./pb_migrations /pb/pb_migrations

# uncomment to copy the local pb_hooks dir into the image
# COPY ./pb_hooks /pb/pb_hooks

EXPOSE 8080

# start PocketBase
ENTRYPOINT ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
