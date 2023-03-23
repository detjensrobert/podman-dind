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

# run podman daemon over tcp instead of default socket
EXPOSE 2375
ENTRYPOINT [ "podman", "--log-level=info", "system", "service", "--timeout=0", "tcp://0.0.0.0:2375" ]
