# PurpurMC Container

Container image for [PurpurMC](https://purpurmc.org/docs/purpur/), a high performance [Minecraft](https://minecraft.net) server based on [PaperMC](https://papermc.io/).

## Build

View the list of available Minecraft versions here: [https://api.purpurmc.org/v2/purpur](https://api.purpurmc.org/v2/purpur)

View the list of builds for a specific Minecraft version as such: `https://api.purpurmc.org/v2/purpur/<version>`

To build the image, you can specify the version and build number as build args:

```bash
podman build --build-arg VERSION=1.21.1 --build-arg BUILD_NO=2321 -t purpurmc:1.21.1-2321 .
```

If you don't specify a version, the current Minecraft version will be used.
If you don't specify a build number, the latest build will be used.

## Pull

## References

- Java start script generator for the server: [https://docs.papermc.io/misc/tools/start-script-gen](https://docs.papermc.io/misc/tools/start-script-gen)
