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
	gcc \
	make \
	py3-pip \
	python3-dev && \
 echo "**** install packages ****" && \
 apk add --no-cache \
	jq \
	py3-openssl \
	py3-setuptools \
	python3 && \
 echo "**** install pip packages ****" && \
 pip3 install --no-cache-dir -U \
 	APScheduler \
	arrow \
	beautifulsoup4 \
	bleach \
	bs4 \
	certifi \
	cffi \
	chardet \
	cheroot \
	CherryPy \
	click \
	cloudinary \
	configobj \
	cryptography \
	distro \
	dnspython \
	facebook-sdk \
	feedparser \
	future \
	geoip2 \
	gntp \
	httpagentparser \
	idna \
	importlib-metadata \
	importlib-resources \
	infi.systray \
	ipwhois \
	IPy \
	jaraco.classes \
	jaraco.collections \
	jaraco.functools \
	jaraco.text \
	logutils \
	Mako \
	MarkupSafe \
	maxminddb \
	mock \
	more-itertools \
	oauthlib \
	packaging \
	paho-mqtt \
	passlib \
	pip-tools \
	portend \
	profilehooks \
	pycparser \
	PyJWT \
	PyNMA \
	pyOpenSSL \
	pyparsing \
	python-dateutil \
	python-twitter \
	pytz \
	requests \
	requests-oauthlib \
	six \
	soupsieve \
	tempora \
	tzlocal \
	urllib3 \
	webencodings \
	websocket-client \
	xmltodict \
	zc.lockfile \
	zipp \
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
