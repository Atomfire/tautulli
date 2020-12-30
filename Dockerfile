FROM ghcr.io/linuxserver/baseimage-alpine:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
ARG TAUTULLI_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="nemchik,thelamer"

# Inform app this is a docker env
ENV TAUTULLI_DOCKER=True

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
    curl \
    g++ \
    make \
    python3 \
    py3-virtualenv \
    gcc \
    git \
    python3 \
    python3-dev \
    py3-pip \
    musl-dev && \
 echo "**** install packages ****" && \
 apk add --no-cache \
    jq \
    py3-openssl \
    py3-setuptools \
    python3 \
    py3-virtualenv \
    gcc \
    git \
    python3 \
    python3-dev \
    py3-pip \
    musl-dev && \
 echo "**** install pip packages ****" && \
 pip3 install --no-cache-dir -U \
    pytz \
	mock \
	plexapi \
	pycryptodomex && \
 echo "**** install app ****" && \
 mkdir -p /app/tautulli && \
 if [ -z ${TAUTULLI_RELEASE+x} ]; then \
	TAUTULLI_RELEASE=$(curl -sX GET "https://api.github.com/repos/zSeriesGuy/Tautulli/releases/latest" \
	| jq -r '. | .tag_name'); \
 fi && \
 curl -o \
 /tmp/tautulli.tar.gz -L \
	"https://github.com/zSeriesGuy/Tautulli/archive/${TAUTULLI_RELEASE}.tar.gz" && \
 tar xf \
 /tmp/tautulli.tar.gz -C \
	/app/tautulli --strip-components=1 && \
 echo "**** Hard Coding versioning ****" && \
 echo "${TAUTULLI_RELEASE}" > /app/tautulli/version.txt && \
 echo "master" > /app/tautulli/branch.txt && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config
EXPOSE 8181
