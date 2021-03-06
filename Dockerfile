FROM ubuntu:xenial
# TODO: switch to Alpine.

ARG FACTORIO_DIRECTORY=/opt/factorio
ARG FACTORIO_PORT=34197
ARG FACTORIO_SHA1=127e7ff484ab263b13615d6114013ce0a66ac929
ARG FACTORIO_VERSION=0.16.51

# TODO: more directories and options.
ENV FACTORIO_BINARY=${FACTORIO_DIRECTORY}/bin/x64/factorio \
    FACTORIO_DIRECTORY=${FACTORIO_DIRECTORY} \
    FACTORIO_DIRECTORY_BIN=${FACTORIO_DIRECTORY}/bin \
    FACTORIO_DIRECTORY_CONFIG=${FACTORIO_DIRECTORY}/config \
    FACTORIO_DIRECTORY_DATA=${FACTORIO_DIRECTORY}/data \
    FACTORIO_DIRECTORY_LOG=${FACTORIO_DIRECTORY}/log \
    FACTORIO_DIRECTORY_MODS=${FACTORIO_DIRECTORY}/mods \
    FACTORIO_DIRECTORY_SAVES=${FACTORIO_DIRECTORY}/saves \
    FACTORIO_DOWNLOAD_PATH=${FACTORIO_DIRECTORY}/factorio_headless_x64_${FACTORIO_VERSION}.tar.xz \
    FACTORIO_DOWNLOAD_URL=https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64 \
    FACTORIO_PORT=${FACTORIO_PORT} \ 
    FACTORIO_SHA1=${FACTORIO_SHA1} \ 
    FACTORIO_VERSION=${FACTORIO_VERSION}

RUN apt-get update && \
    apt-get install -y \
        curl \
        xz-utils

RUN mkdir -p \ 
        "${FACTORIO_DIRECTORY}" \
        "${FACTORIO_DIRECTORY_BIN}" \
        "${FACTORIO_DIRECTORY_CONFIG}" \
        "${FACTORIO_DIRECTORY_DATA}" \
        "${FACTORIO_DIRECTORY_LOG}" \
        "${FACTORIO_DIRECTORY_MODS}" \
        "${FACTORIO_DIRECTORY_SAVES}" && \
    curl -L -o "${FACTORIO_DOWNLOAD_PATH}" -s -S "${FACTORIO_DOWNLOAD_URL}" && \
    echo "${FACTORIO_SHA1}  ${FACTORIO_DOWNLOAD_PATH}" | sha1sum -c && \
    tar -C $(dirname "${FACTORIO_DIRECTORY}") -xvf "${FACTORIO_DOWNLOAD_PATH}"

EXPOSE ${FACTORIO_PORT}/udp

RUN ["/bin/bash", "-c", "${FACTORIO_BINARY} -v --create ${FACTORIO_DIRECTORY_SAVES}/default.zip --console-log ${FACTORIO_DIRECTORY_LOG}/default.log"]

CMD ["/bin/bash", "-c", "${FACTORIO_BINARY} -v --start-server ${FACTORIO_DIRECTORY_SAVES}/default.zip --console-log ${FACTORIO_DIRECTORY_LOG}/default.log"]
