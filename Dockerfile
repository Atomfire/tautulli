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
 	APScheduler==3.6.3 \
	arrow==0.15.6 \
	beautifulsoup4==4.9.0 \
	bleach==3.1.5 \
	bs4==0.0.1 \
	certifi==2020.4.5.1 \
	cffi==1.14.0 \
	chardet==3.0.4 \
	cheroot==8.3.0 \
	CherryPy==18.6.0 \
	click==7.1.2 \
	cloudinary==1.20.0 \
	configobj==5.0.6 \
	cryptography==2.9.2 \
	distro==1.5.0 \
	dnspython==1.16.0 \
	facebook-sdk==3.1.0 \
	feedparser==5.2.1 \
	future==0.18.2 \
	geoip2==3.0.0 \
	gntp==1.0.3 \
	httpagentparser==1.9.0 \
	idna==2.9 \
	importlib-metadata==1.6.0 \
	importlib-resources==1.5.0 \
	infi.systray==0.1.12 \
	ipwhois==1.1.0 \
	IPy==1.0 \
	jaraco.classes==2.0 \
	jaraco.collections==2.1 \
	jaraco.functools==2.0 \
	jaraco.text==3.2.0 \
	logutils==0.3.5 \
	Mako==1.1.2 \
	MarkupSafe==1.1.1 \
	maxminddb==1.5.2 \
	mock==3.0.5 \
	more-itertools==8.2.0 \
	oauthlib==3.1.0 \
	packaging==20.3 \
	paho-mqtt==1.5.0 \
	passlib==1.7.2 \
	pip-tools==5.1.1 \
	portend==2.6 \
	profilehooks==1.11.2 \
	pycparser==2.20 \
	PyJWT==1.7.1 \
	PyNMA==1.0 \
	pyOpenSSL==19.1.0 \
	pyparsing==2.4.7 \
	python-dateutil==2.8.1 \
	python-twitter==3.5 \
	pytz==2020.1 \
	requests==2.23.0 \
	requests-oauthlib==1.3.0 \
	soupsieve==2.0 \
	tempora==1.14.1 \
	tzlocal==2.0.0 \
	urllib3==1.25.9 \
	webencodings==0.5.1 \
	websocket-client==0.56.0 \
	xmltodict==0.12.0 \
	zc.lockfile==2.0 \
	zipp==1.2.0 \
	wheel \
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
