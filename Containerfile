ARG PODMAN_VER=latest
FROM quay.io/podman/stable:${PODMAN_VER}

# rootless needs dbus-launch
RUN dnf install -y dbus-x11 && \
    dnf clean all && \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*

# allow pulling from docker.io unqualified like docker does
RUN echo 'unqualified-search-registries = ["docker.io"]' > /etc/containers/registries.conf.d/00-unqualified.conf

# base image already has rootless setup
USER podman

# rootless needs FUSE support
# VOLUME /dev/fuse

# use volume for container storage to support native overlay
# VOLUME /var/lib/containers
VOLUME /home/podman/.local/share/containers/storage/overlay

# run podman daemon over tcp instead of default socket
EXPOSE 2375
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD env CONTAINER_HOST=tcp://localhost:2375 podman info

ENTRYPOINT [ "podman", "--log-level=info", "system", "service", "--timeout=0", "tcp://0.0.0.0:2375" ]
