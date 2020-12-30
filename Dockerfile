FROM tautulli/tautulli-baseimage:python3

LABEL maintainer="Tautulli"

ARG BRANCH
ARG COMMIT
ARG TAUTULLI_RELEASE

ENV TAUTULLI_DOCKER=True
ENV TZ=UTC

WORKDIR /app

RUN \
  groupadd -g 1000 tautulli && \
  useradd -u 1000 -g 1000 tautulli && \
  echo "**** install app ****" && \
  mkdir -p /app && \
  if [ -z ${TAUTULLI_RELEASE+x} ]; then \
 	TAUTULLI_RELEASE=$(curl -sX GET "https://api.github.com/repos/Tautulli/Tautulli/releases/latest" \
 	| jq -r '. | .tag_name'); \
  fi && \
  curl -o \
  /tmp/tautulli.tar.gz -L \
 	"https://github.com/Tautulli/Tautulli/archive/${TAUTULLI_RELEASE}.tar.gz" && \
  tar xf \
  /tmp/tautulli.tar.gz -C \
 	/app --strip-components=1 && \
  echo "**** Hard Coding versioning ****" && \
  echo "${TAUTULLI_RELEASE}" > /app/version.txt && \
  echo "master" > /app/branch.txt && \
  echo "**** cleanup ****" && \
  rm -rf \
	/root/.cache \
	/tmp/*

COPY /app .

CMD [ "python", "Tautulli.py", "--datadir", "/config" ]
ENTRYPOINT [ "./start.sh" ]

VOLUME /config
EXPOSE 8181
HEALTHCHECK --start-period=90s CMD curl -ILfSs http://localhost:8181/status > /dev/null || curl -ILfkSs https://localhost:8181/status > /dev/null || exit 1
