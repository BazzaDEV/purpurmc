
FROM registry.access.redhat.com/ubi9/ubi:9.4 as prereqs

ARG VERSION=current \
    BUILD_NO=latest

RUN dnf -y update && \
    dnf -y install --setopt=install_weak_deps=False --nodocs jq && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN if [ "${VERSION}" = "current" ]; then \
        MC_VERSION=$(curl -s https://api.purpurmc.org/v2/purpur | jq -r '.metadata.current'); \
    else \
        MC_VERSION=${VERSION}; \
    fi && \
    if [ "${BUILD_NO}" = "latest" ]; then \
        PURPUR_BUILD_NO=$(curl -s https://api.purpurmc.org/v2/purpur/${MC_VERSION} | jq -r '.builds.latest'); \
    else \
        PURPUR_BUILD_NO=${BUILD_NO}; \
    fi && \
    curl -o server.jar https://api.purpurmc.org/v2/purpur/${MC_VERSION}/${PURPUR_BUILD_NO}/download

FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.20 as runner

ARG EULA=true

ENV JAVA_OPTS="-XX:+AlwaysPreTouch \
-XX:+DisableExplicitGC \
-XX:+ParallelRefProcEnabled \
-XX:+PerfDisableSharedMem \
-XX:+UnlockExperimentalVMOptions \
-XX:+UseG1GC \
-XX:G1HeapRegionSize=8M \
-XX:G1HeapWastePercent=5 \
-XX:G1MaxNewSizePercent=40 \
-XX:G1MixedGCCountTarget=4 \
-XX:G1MixedGCLiveThresholdPercent=90 \
-XX:G1NewSizePercent=30 \
-XX:G1RSetUpdatingPauseTimePercent=5 \
-XX:G1ReservePercent=20 \
-XX:InitiatingHeapOccupancyPercent=15 \
-XX:MaxGCPauseMillis=200 \
-XX:MaxTenuringThreshold=1 \
-XX:SurvivorRatio=32 \
-Dusing.aikars.flags=https://mcflags.emc.gs \
-Daikars.new.flags=true"

RUN mkdir /opt/mc && chown -R $(id -u):$(id -g) /opt/mc

WORKDIR /opt/mc
COPY --from=prereqs /server.jar server.jar
RUN echo "eula=${EULA}" > eula.txt

EXPOSE 25565

RUN echo $(env)

ENTRYPOINT java ${JAVA_OPTS} -jar server.jar nogui
