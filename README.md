# PurpurMC Container

Container image for [PurpurMC](https://purpurmc.org/docs/purpur/), a high performance [Minecraft](https://minecraft.net) server based on [PaperMC](https://papermc.io/).

## Build

View the list of available Minecraft versions here: [https://api.purpurmc.org/v2/purpur](https://api.purpurmc.org/v2/purpur)

View the list of builds for a specific Minecraft version as such: `https://api.purpurmc.org/v2/purpur/<version>`

### Single image

To build the image, you can specify the version and build number as build args:

```bash
podman build --build-arg VERSION=1.21.1 --build-arg BUILD_NO=2321 -t purpurmc:1.21.1-2321 .
```

If you don't specify a version, the current Minecraft version will be used.
If you don't specify a build number, the latest build will be used.

### Multi-Platform

You need `buildah` and `qemu-user-static`.

For the latter, you can install with your package manager or for RHEL/Rocky/etc, look here: [https://rhel.pkgs.org/9/ghettoforge-x86_64/qemu-user-static-8.2.0-1.2.gf.el9.x86_64.rpm.html](https://rhel.pkgs.org/9/ghettoforge-x86_64/qemu-user-static-8.2.0-1.2.gf.el9.x86_64.rpm.html)

Look here for how to build multiplatform images using Buildah: [https://medium.com/oracledevs/building-multi-architecture-containers-with-buildah-44ed100ec3f3](https://medium.com/oracledevs/building-multi-architecture-containers-with-buildah-44ed100ec3f3)

Notes on building and pushing:

- To build the images:

```bash
buildah build --jobs=2 \
  --platform=linux/arm64/v8,linux/amd64 \
  --manifest ghcr.io/bazzadev/purpurmc:v1.21.1-2321 \
  .
```

- Then, add additional tags for the manifest:

```bash
buildah manifest add ghcr.io/bazzadev/purpurmc:v1.21.1-2321 ghcr.io/bazzadev/purpurmc:v1.21.1-latest
buildah manifest add ghcr.io/bazzadev/purpurmc:v1.21.1-2321 ghcr.io/bazzadev/purpurmc:v1.21.1
```

- Finally, push the manifests:

```bash
buildah manifest push ghcr.io/bazzadev/purpurmc:v1.21.1-2321
buildah manifest push ghcr.io/bazzadev/purpurmc:v1.21.1-latest
buildah manifest push ghcr.io/bazzadev/purpurmc:v1.21.1
```

## Pull

## References

- Java start script generator for the server: [https://docs.papermc.io/misc/tools/start-script-gen](https://docs.papermc.io/misc/tools/start-script-gen)
