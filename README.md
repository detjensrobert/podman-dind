# podman-dind

The `quay.io/podman/stable` container, set up to expose the Podman socket.

Intended for use in Gitlab CI DIND as a rootless replacement for [rootful, privileged `docker:dind`](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#use-docker-in-docker) while being simpler to use than [Gitlab-recommended Kaniko](https://docs.gitlab.com/ee/ci/docker/using_kaniko.html).

## Usage

As standalone image:

```sh
podman run -d
  --name podman-dind
  --port 2375:2375
  ghcr.io/detjensrobert/podman-dind
```

In Gitlab CI:

```yaml
container-build:
  stage: build

  services:
    - name: ghcr.io/detjensrobert/podman-dind
      alias: dind

  image: docker:latest
  variables:
    DOCKER_HOST: tcp://dind:2375
  script:
    - docker build --tag example-image:latest ...
```

The runner does not need to be privileged.
